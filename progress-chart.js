// Google Charts progress tracking
google.charts.load('current', {'packages':['corechart']});
google.charts.setOnLoadCallback(drawChart);

function drawChart() {
    // Fetch progress data
    fetch('progress_data.json')
        .then(response => response.json())
        .then(data => {
            var chartData = new google.visualization.DataTable();
            chartData.addColumn('datetime', 'Date');
            chartData.addColumn('number', 'Word Count');

            // Convert data to chart format
            var rows = data.map(function(item) {
                return [new Date(item.datetime), item.wordCount];
            });

            chartData.addRows(rows);

            var options = {
                title: 'Writing Progress Over Time',
                hAxis: {
                    title: 'Date',
                    format: 'MM/dd/yyyy',
                    titleTextStyle: {color: '#333'},
                    gridlines: {color: '#ccc'}
                },
                vAxis: {
                    title: 'Word Count',
                    titleTextStyle: {color: '#333'},
                    gridlines: {color: '#ccc'},
                    minValue: 0
                },
                backgroundColor: '#f9f9f9',
                series: {
                    0: {color: '#1f77b4', lineWidth: 3, pointSize: 6}
                },
                legend: {position: 'bottom'},
                chartArea: {left: 80, top: 50, width: '80%', height: '70%'}
            };

            var chart = new google.visualization.LineChart(document.getElementById('progressChart'));
            chart.draw(chartData, options);
        })
        .catch(error => {
            console.error('Error loading progress data:', error);
            document.getElementById('progressChart').innerHTML =
                '<p style="text-align: center; color: #666; padding: 50px;">No progress data available yet. Run update_word_count.ps1 to start tracking progress.</p>';
        });
}
