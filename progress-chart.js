// Google Charts progress tracking
google.charts.load('current', {'packages':['corechart']});

function calculateLinearRegression(data) {
    const n = data.length;
    if (n < 2) return null;

    // Convert dates to days since first data point for calculation
    const firstDate = new Date(data[0].datetime);
    const points = data.map(item => {
        const date = new Date(item.datetime);
        const daysDiff = (date - firstDate) / (1000 * 60 * 60 * 24);
        return { x: daysDiff, y: item.wordCount };
    });

    const sumX = points.reduce((sum, p) => sum + p.x, 0);
    const sumY = points.reduce((sum, p) => sum + p.y, 0);
    const sumXY = points.reduce((sum, p) => sum + p.x * p.y, 0);
    const sumXX = points.reduce((sum, p) => sum + p.x * p.x, 0);

    const slope = (n * sumXY - sumX * sumY) / (n * sumXX - sumX * sumX);
    const intercept = (sumY - slope * sumX) / n;

    return { slope, intercept, firstDate };
}

function drawChart(targetWords) {
    // Fetch progress data
    fetch('progress_data.json')
        .then(response => response.json())
        .then(data => {
            var chartData = new google.visualization.DataTable();
            chartData.addColumn('datetime', 'Date');
            chartData.addColumn('number', 'Actual Word Count');
            chartData.addColumn('number', 'Forecast');
            chartData.addColumn('number', 'Target');
            chartData.addColumn('number', 'Aug 14th Goal');

            // Convert actual data to chart format
            var rows = data.map(function(item) {
                return [new Date(item.datetime), item.wordCount, null, null, null];
            });

            // Calculate linear regression for forecast
            const regression = calculateLinearRegression(data);
            if (regression) {
                const { slope, intercept, firstDate } = regression;
                const currentWords = data[data.length - 1].wordCount;
                const lastDate = new Date(data[data.length - 1].datetime);

                // Calculate days needed to reach target
                const lastDaysDiff = (lastDate - firstDate) / (1000 * 60 * 60 * 24);
                const currentPredicted = slope * lastDaysDiff + intercept;
                const daysToTarget = (targetWords - intercept) / slope;
                const targetDate = new Date(firstDate.getTime() + daysToTarget * 24 * 60 * 60 * 1000);

                // Calculate August 14th goal line
                const aug14Date = new Date('2025-08-14');
                const daysToAug14 = (aug14Date - lastDate) / (1000 * 60 * 60 * 24);
                const wordsNeededPerDay = (targetWords - currentWords) / daysToAug14;

                // Add daily data points for August 14th goal line
                const startDate = new Date(lastDate);
                startDate.setHours(0, 0, 0, 0); // Start from beginning of next day
                startDate.setDate(startDate.getDate() + 1);

                for (let d = new Date(startDate); d <= aug14Date; d.setDate(d.getDate() + 1)) {
                    const daysSinceStart = (d - lastDate) / (1000 * 60 * 60 * 24);
                    const goalWords = currentWords + (daysSinceStart * wordsNeededPerDay);
                    rows.push([new Date(d), null, null, null, Math.round(goalWords)]);
                }

                // Add forecast points for the natural progression
                const forecastDays = Math.max(30, (targetDate - lastDate) / (1000 * 60 * 60 * 24) + 30);
                for (let i = 0; i <= forecastDays; i += 5) {
                    const forecastDate = new Date(lastDate.getTime() + i * 24 * 60 * 60 * 1000);
                    const daysSinceFirst = (forecastDate - firstDate) / (1000 * 60 * 60 * 24);
                    const forecastWords = slope * daysSinceFirst + intercept;

                    rows.push([forecastDate, null, Math.round(forecastWords), targetWords, null]);
                }

                console.log(`Forecast: ${Math.round((targetDate - new Date()) / (1000 * 60 * 60 * 24))} days to reach 100k words (${targetDate.toISOString().split('T')[0]})`);
            }

            chartData.addRows(rows);

            var options = {
                //title: 'Writing Progress & Forecast',
                // titleTextStyle: {
                //     color: '#ffffff',
                //     fontSize: 18,
                //     bold: true
                // },
                hAxis: {
                    title: 'Date',
                    format: 'yyyy-MM-dd',
                    titleTextStyle: {color: '#ffffff'},
                    textStyle: {color: '#ffffff'},
                    gridlines: {color: '#444444'},
                    minorGridlines: {color: '#333333'}
                },
                vAxis: {
                    title: 'Word Count',
                    titleTextStyle: {color: '#ffffff'},
                    textStyle: {color: '#ffffff'},
                    gridlines: {color: '#444444'},
                    minorGridlines: {color: '#333333'},
                    minValue: 0,
                    format: '#,###'
                },
                backgroundColor: '#000000',
                series: {
                    0: {color: '#ffff00', lineWidth: 2, pointSize: 0, type: 'line'}, // Actual - Yellow
                    1: {color: '#ff8800', lineWidth: 1, pointSize: 0, lineDashStyle: [5, 5], type: 'line'}, // Forecast - Orange dashed
                    2: {color: '#00ff00', lineWidth: 1, pointSize: 0, lineDashStyle: [2, 8], type: 'line'}, // Target - Green dashed
                    3: {color: '#ff00ff', lineWidth: 1, pointSize: 0, lineDashStyle: [2, 2], type: 'line'} // Aug 14th Goal - Magenta with points
                },
                legend: {
                    position: 'bottom',
                    textStyle: {color: '#ffffff'},
                    alignment: 'center'
                },
                chartArea: {
                    left: 80,
                    top: 40,
                    width: '85%',
                    height: '80%',
                    backgroundColor: '#000000'
                }
            };

            var chart = new google.visualization.LineChart(document.getElementById('progressChart'));
            chart.draw(chartData, options);
        })
        .catch(error => {
            console.error('Error loading progress data:', error);
            document.getElementById('progressChart').innerHTML =
                '<p style="text-align: center; color: #ffffff; padding: 50px; background-color: #000000;">No progress data available yet. Run update_word_count.ps1 to start tracking progress.</p>';
        });
}
