Pod::Spec.new do |s|
  s.name             = "PickerCells"
  s.version          = "1.1.0"
  s.summary          = "UIDatePicker or UIPickerView that will slide in/out by tapping on the cell in your UITableView"
  s.description      = <<-DESC
    This class adds UIDatePicker or UIPickerView that will slide in/out by tapping on the cell in your UITableView.
    Inspired by Apple's DateCell example and andjash's DateCellsController.
                       DESC
  s.homepage         = "https://github.com/zigdanis/PickerCells"
  s.screenshots      = "http://i.imgur.com/Z8vbhNFl.png", "http://i.imgur.com/WfgTUtel.png"
  s.license          = 'MIT'
  s.author           = { "Danis Ziganshin" => "zigdanis@gmail.com" }
  s.source           = { :git => "https://github.com/zigdanis/PickerCells.git", :tag => s.version.to_s }
  s.platform         = :ios, '6.0'
  s.requires_arc     = true
  s.source_files     = 'PickerCells'
end