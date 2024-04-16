# Sportsbook App

## Technology choices

The app is based on UIKit with an MVVM pattern. Coordinators are used for screen routing.

Combine is used for the bindings between the VCs and the VMs. The Coordinators are delegates of the VMs.
Swift Concurrency is used for async tasks, mainly API requests.

## Setup

No special setup is needed to run the app. No 3rd party dependencies are used and the app should run out of the box.
In case the API domain/base url you use is not the local one("http://localhost:8080"), it can be changed through the APIConfig's baseURL property(it's hardcoded there at this point). 
Same goes with authorization token.

## Future improvements

Of course a lot can be improved in the app. The implementation is relatively basic. As the app gets more complex, some of the core classes will probebly need to be extended.

### General

* Managed to add just a few tests, there's a lot more to cover. May add a few more after I send the task in the current state.
* Haven't spent much time to review the code, for sure there are things to be optimized or refactored. 
* Have left myself some TODOs on debts that I have left in the first place  
* Better error handling will be needed, it is now very basic.
* Loading states can be improved as well. Visually as well - I've just added pull to refresh, that I also use while loading, but it doesn't look good on transition.
* Can add a placeholder text if the results are empty
* The Rugby and Football market type names are slightly different and the Rugby string is too long - "Regular Time Match Odds". This causes the UI to be ugly. From the designs it's unclear what the desired outcome should be in this case, so it's left as it is. Perhaps the API can just return the same string as in Football, as the rest of the model seems to be the same.
* In the WinDrawWin Market types, most probably the array of runners is returned with the correct home-draw-away order. However, since this is not documented, I've extracted the Home and Away team names from the sport Event name. These are not fully consistent and the team names may be separated by "v" or "vs", which adds some complexity in the logic. However, I thought this is the safest bet to extract the correct Home/Away names.
* Generally the code needs some more love and refactoring - from multiple data structures in single files through more complex that it can be logic, a bit of duplicated code or patterns that can be improved.

### APIKit

* Will need proper authorization mechanism for sure in future. This alone brings up lots to be done to handle unauthorized calls, refresh of tokens, retries etc.
* Will probably need multiple environment management
* Will be good if there's error logging with different levels for easier debugging
* Needs better error handling.

### Coordinators

* The implementation will need to be extended with a few more helper functions in a more complex app with tab bars, long navigation, modals etc. For example finding coordinators in the stack or poping to concrete one, removing more children at once etc.
* ViewControllers will best implement a protocol to start/finish as well, instead of having to call whatever function is needed right after the initialization. This adds some logic in the coordinators, that shouldn't be there.
