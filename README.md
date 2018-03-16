# ENTRefreshControl

This document contains information about `ENTRefreshControl` class to use external `UIView` instead of native view usually bind with `UIScrollView`

## Pod

``` pod "ENTRefreshControl" ```


## Initialise
Every things with `ENTRefreshControl` works just the same as native `UIRefreshControl` but with few changes.

1: You can assign your custom view to display and animate with refresh controls' pull state. For this all you need is to create your custom view and place it some where on Screen e.g on `UINavigationBar` or any where you want. After that just pass the reference of that view to `ENTRefreshControl` object `loaderView`.

```
let refreshControl = ENTRefreshControl()
refreshControl.loaderView = yourCustomView
refreshControl.rotationSpeed = .double
```

2: You can also slow down or faster the rotation of your custom view when you are pulling to refresh. For this we have enumeration with values.

```
enum Speed {
   case same
   case half
   case double
}
```
3: You can stop your view's animation without calling `refreshControl.endRefreshing()` function and start animation without calling `refreshControl.beginRefreshing()` like this.

```
refreshControl.startRotate // to start your animation
refreshControl.stopRotate // to end your animation
```
>starting animation without calling `refreshControl.beginRefreshing()` will give you `false` when you will triger `refreshControl.isRefreshing()` function.



4: You can now register a completion handler to get current state of Control which will invoke when ever an event is occur on refresh control.

```
refControl.pullState = { state, frame in
    //state is an enumeration with name PullState and defined below.
    //frame is the current of of refreshControl with respect to its superview.
}
```
`PullState` is an enumeration which contains information about the state of refresh control's pulling state. E.g User is pulling downward, upward, isLoading or none.

```
public enum PullState{
    case up
    case down
    case loading
    case none
}
```
