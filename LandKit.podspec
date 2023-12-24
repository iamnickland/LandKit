Pod::Spec.new do |s|
  s.name         = "LandKit"
  s.version      = "1.0.19"
  s.summary      = "The package of useful tools, include categories and classes"
  s.description  = <<-DESC
                  The package of useful tools, include categories and classes
                  DESC

  s.homepage     = "https://github.com/iamnickland/LandKit"
  s.license      = { :type => "MIT" }
  s.authors      = { 'nickland' => 'nick.rango.land@gmail.com'}
  
  s.swift_versions = ['5.0']
  s.ios.deployment_target = "13.0"

  s.source       = { :git => "https://github.com/iamnickland/LandKit.git", :tag => s.version }
  s.source_files = ['Sources/LandKit/**/*.swift']
  s.requires_arc = true
  s.frameworks = "CFNetwork", "Accelerate"
  s.ios.vendored_frameworks = "Queuer.xcframework"
end
