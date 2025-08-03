pushd D:\projects\github\dylanbeattie\rouge
gem build ./rouge.gemspec
cp rouge-4.6.0.gem 'D:\Obsidian\Dylan''s Obsidian Vault\css4eng\gems'
popd
gem unpack ./gems/rouge-4.6.0.gem --target ./gems

