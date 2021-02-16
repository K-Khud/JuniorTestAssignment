# Junior Developer Assignment
Legend: Our client is a clothing brand that is looking for a simple web app to use in their warehouses. 
To do their work efficiently, the warehouse workers need a fast and simple listing page per product category, where they can check simple product and availability information from a single UI.
There are three product categories they are interested in for now: gloves, facemasks, and beanies. 

# Technical Solutions  
  
**Architecture**  
  
In this project I followed MVС architecture approach with the difference in the `model` part.

`Model` in my project is presented by a `repository`, which receives the query from `controller` to get list of products or the product details.

`Repository` checks if the data is available from the local cache, and, if it receives nil from the cache, then it sends the fetch request to the `network` a.k.a `BadApiClient`. 
  
The `BadApiClient` module contains code working with the backend. 
      
**Models**  
  
The `Model` module contains `data` models. The `ProductModel` models represent exact structure of the backend responses and are used for parsing.   
`Availability` property in the `ProductModel` is optional, since it received from the separate fetching request with the response delay.
Also, the optionals help to handle the malformed backend response without the app crashing. 

**Cache**  
  
The `ProductsCache` & `Availability` modules are the local data storages implemented with the use of `CoreData` framework.
There are two entities: 
`ProductCache` - to save the list of products per category.
`Content` - to save the availability records per manufacturer from the separate backend response. Single record is the `availability` per product `id`.

## Requirements

* Swift 5.0
* Xcode 12.2
* iOS 13.0+

## Features

* Fast switching between categories with the tabBar.
* Fast switching between categories with the tabBar.
* Search within a category across id/name/manufacturer.
* Loading animation to add responsiveness to the app.
