pushd D:\projects\github\dylanbeattie\rouge
gem build ./rouge.gemspec
cp rouge-4.6.0.gem 'D:\projects\github\ursatile\css4eng\gems'
popd
gem unpack ./gems/rouge-4.6.0.gem --target ./gems

