Pod::Spec.new do |s|
  s.name         = "LandKit"
  s.version      = "1.1.1"
  s.summary      = "The package of useful tools, include categories and classes"
  s.description  = <<-DESC
                  The package of useful tools, include categories and classes, and Life, thin and light-off time and time again Frivolous tireless I heard the echo, from the valleys and the heart
                  Open to the lonely soul of sickle harvesting  Repeat outrightly, but also repeat the well-being of eventually swaying in the desert oasis I believe I am Born as the bright summer flowers
                  Do not withered undefeated fiery demon rule
                  DESC

  s.homepage     = "https://github.com/iamnickland/LandKit"
  s.license      = { :type => 'Apache License, Version 2.0', :text => <<-LICENSE
    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
    LICENSE
  }
  
  s.authors      = { 'nickland' => 'nick.rango.land@gmail.com'}
  
  s.swift_versions = ['5.0']
  s.ios.deployment_target = "13.0"

  s.source       = { :git => "https://github.com/iamnickland/LandKit.git", :tag => s.version }
  s.source_files = ['Sources/LandKit/**/*.swift']
  s.requires_arc = true
  s.frameworks = "CFNetwork", "Accelerate"
  s.ios.vendored_frameworks = "Queuer.xcframework"
end
