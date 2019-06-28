Pod::Spec.new do |s|
  s.name            = "C0T0"
  s.version         = "0.3.0"
  s.summary         = "HTTP networking library."
  s.description     = "HTTP networking library written in Swift."
  s.homepage        = "https://github.com/tooploox/C0T0"
  s.license         = "MIT"
  s.author          = { "TPLX iOS team" => "ios@tooploox.com" }
  s.platform        = :ios, "10.0"
  s.source          = { :git => "https://github.com/tooploox/C0T0.git", :tag => "v0.3.0" }
  s.source_files    = "C0T0/**/*.swift"
  s.swift_version   = "5.0"
end
