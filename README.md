# Junior Developer Assignment
Legend: Our client is a clothing brand that is looking for a simple web app to use in their warehouses. 
To do their work efficiently, the warehouse workers need a fast and simple listing page per product category, where they can check simple product and availability information from a single UI.
There are three product categories they are interested in for now: gloves, facemasks, and beanies. 

For the experimental purpose, I imagined a case of a transformation stage project: migration from UIKit to SwiftUI. UI of both SwiftUI-built and UIKit-built views are kept identical. 

# Technical Solutions  
  
**Architecture**  
  
In this project I followed MVС architecture approach with the difference in the `model` part.

`Model` in my project is presented by a `repository`, which receives the query from `controller` to get list of products or the product details.

`Repository` checks if the data is available from the local cache, and, if it receives `nil` from the cache, then it sends the fetch request to the `network` a.k.a `BadApiClient`. 
  
The `BadApiClient` module contains code working with the backend.

Following the requirement for demonstrating the UIKit to SwiftUI migration, the `CustomTabBarController` holds SwiftUI View `glovesRootView` and two UIKit view controllers for facemasks and beanies.

The corresponsing SwiftUI wrappers such as `SwiftUILoadingView` and `SwiftUISearchBar`, as well as the publisher `BridgingManagerForCategory` are created for interfacing with UIKit project module.

**Models**  
  
The `Model` module contains `data` models. The `ProductModel` models represent exact structure of the backend responses and are used for parsing.   
`Availability` property in the `ProductModel` is optional, since it received from the separate fetching request with the response delay.
Also, the optionals help to handle the malformed backend response without the app crashing. 

**Cache**  
  
The `ProductsCache` & `AvailabilityCache` modules are the local data storages implemented with the use of `CoreData` framework.
There are two entities: 
`ProductCache` - to save the list of products per category.
`Content` - to save the availability records per manufacturer from the separate backend response. Single record is the `availability` per product `id`.

**Code Style**

`SwiftLint` is integrated into Xcode to follow Swift style and conventions.

## Features

* Local cache with the use of CoreData.
* SwiftUI integrated into the classical UIKit project.
* Fast switching between categories with the tabBar.
* Search within a category across id/name/manufacturer.
* Loading animation to add responsiveness to the app.

## Limitations

* I didn't completely replaced UIKit with the SwiftUI due to the following reasons:
  * Some of the UI components don't exist in SwiftUI, i.e. SearchBar. I've built a wrapper for it.
  * I would like illustrate the "migrating stage" of UIKit project, when going from UIKit to SwiftUI. For the real project I would consider replacing the UIKit components as much as possible.
  
* I didn't implement pagination. The task didn't require it explicitly, I'd definetely add it in future, since the product list contains more than 6000 elements. 
  
* I didn't implement testing. On production I would add the following tests:
  * Unit tests for URL constructor: method of `BadApiClient`;
  * Integration tests for parsing of data models. For that I would add json files and parse them with the existing models. The tests would check that fields of parsed models have same values as jsons.

## Requirements

* Swift 5.0
* Xcode 12.2
* iOS 14.1+
