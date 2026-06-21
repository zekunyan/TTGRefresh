Pod::Spec.new do |s|
  s.name             = 'TTGRefresh'
  s.version          = '0.1.0'
  s.summary          = 'A modern Swift pull-to-refresh and infinite-loading component for UIKit scroll views.'
  s.description      = <<-DESC
TTGRefresh provides pull-to-refresh headers, load-more footers, auto-loading footers,
no-more-data states, async actions, and custom refresh content views for UIScrollView,
UITableView, and UICollectionView.
  DESC
  s.homepage         = 'https://github.com/zekunyan/TTGRefresh'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'tutuge.zekunyan' => 'zekunyan@users.noreply.github.com' }
  s.source           = { :git => 'https://github.com/zekunyan/TTGRefresh.git', :tag => s.version.to_s }
  s.swift_version    = '5.9'
  s.platform         = :ios, '16.0'
  s.source_files     = 'Sources/TTGRefresh/**/*.swift'
  s.frameworks       = 'UIKit'
end
