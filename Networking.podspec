Pod::Spec.new do |s|
  s.name            = "Networking"
  s.version         = "0.1.0"
  s.summary         = "HTTP networking library."
  s.description     = "HTTP networking library written in Swift."
  s.homepage        = "https://github.com/tooploox/Networking-iOS"
  s.license         = "MIT"
  s.author          = { "Tplx guys" => "ios@tooploox.com" }
  s.platform        = :ios, "10.0"
  s.source          = { :git => "https://github.com/tooploox/Networking-iOS.git", :tag => "v0.1.0" }
  s.source_files    = "Networking/**/*.swift"
  s.swift_version   = "4.1"
end
