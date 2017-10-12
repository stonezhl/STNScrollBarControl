Pod::Spec.new do |s|
  s.name         = "STNScrollBarControl"
  s.version      = "1.0.0"
  s.summary      = "A scroll bar like Google photo's can scroll scrollview/tableview/collectionview and show text depending on cell"
  s.description  = <<-DESC
                   The scroll bar is subclass of UIControl and it is very easly added to scrollview/tableview/collectionview. It also can show text when implement delegate.
                   DESC
  s.homepage     = "https://github.com/stonezhl/STNScrollBarControl"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Stone Zhang" => "stnzhl@gmail.com" }

  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/stonezhl/STNScrollBarControl.git", :tag => s.version }

  s.source_files  = "STNScrollBarControl", "STNScrollBarControl/**/*.{h,m,swift}"
end
