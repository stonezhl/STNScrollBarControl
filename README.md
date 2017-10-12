# STNScrollBarControl
A scroll bar like Google photo's can scroll scrollview/tableview/collectionview and show text depending on cell

## Demo
![](https://media.giphy.com/media/l1JohuMQjdadiRIek/giphy.gif)

## Who need this?
When you have a large list of cells in tableview or collectionview, sectionIndexTitlesForTableView is not enough.

## Requirements
* Objective-C
* iOS 8.0+
* ARC

## How to use it?
1. Add property
   ```
   @property (strong, nonatomic) STNScrollBar *scrollBar;
   ```
1. Create instance
   ```
   self.scrollBar = [STNScrollBar scrollBar];
   self.scrollBar.scrollView = self.tableView;
   self.scrollBar.delegate = self;
   ```
1. Add view
   * TableView/CollectionView in UIViewController
   ```
   [self.view addSubview:self.scrollBar];
   ```
   * TableViewController/CollectionViewController in NavigationController
   ```
   [self.navigationController.view addSubview:self.scrollBar];
   ```
1. Add viewDidDisappear
   ```
   - (void)viewDidDisappear:(BOOL)animated {
       [self.scrollBar viewDidDisappear];
   }
   ```
1. Add UIScrollViewDelegate
   ```
   - (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
       [self.scrollBar scrollViewWillBeginDragging];
   }

   - (void)scrollViewDidScroll:(UIScrollView *)scrollView {
       [self.scrollBar scrollViewDidScroll];
   }

   - (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
       [self.scrollBar scrollViewDidEndDraggingAndWillDecelerate:decelerate];
   }

   - (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
       [self.scrollBar scrollViewDidEndDecelerating];
   }
   ```
1. Add STNScrollBarDelegate
   ```
   - (NSString *)scrollBar:(STNScrollBar *)scrollBar itemStringAtIndexPath:(NSIndexPath *)indexPath {
       return self.names[indexPath.row]; // anything you want to show based on indexPath
   }
   ```
   
## Installation
### CocoaPods
[CocoaPods](https://cocoapods.org/) is a dependency manager for Cocoa projects. You can install it with the following command:
```
$ gem install cocoapods
```
To integrate STNScrollBarControl into your Xcode project using CocoaPods, specify it to a target in your Podfile:
```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

target 'MyApp' do
  # your other pod
  # ...
  pod 'STNScrollBarControl', '~> 1.0'
end
```
Then, run the following command:
```
$ pod install
```
You should open the {Project}.xcworkspace instead of the {Project}.xcodeproj after you installed anything from CocoaPods.

For more information about how to use CocoaPods, I suggest this [tutorial](https://www.raywenderlich.com/156971/cocoapods-tutorial-swift-getting-started).

## License
STNScrollBarControl is released under the MIT license. See LICENSE for details.
