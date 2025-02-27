# A simplified real-world-project Movie Booking App 🎬 🍿 built with Flutter, Clean Template, BLoC, REST API, Firebase Auth, and Unit Tests (future).

> I’ve open-sourced this project to showcase some of my skills and to help early-career Flutter developers grow in their career.
>
> Like ["Nezha: Birth Of The Demon Child"](https://www.youtube.com/watch?v=xdOgym7MLAU), I believe that for those just starting out in Flutter, completing this project might be a challenge. However, once you get through it, you’ll either succeed or grow stronger. (Không thành công cũng thành nhân) (失败也是成功)
>
> I’ll also support so feel free to start with new issue if you have difficulty because I know it’s not as easy for everyone. :muscle:


## Happy new year 2025 🎉

2025 kicks off with AI evolving at an incredible pace, but also brings a wave of layoffs in the IT industry. Don’t be too afraid! This is not the end—stay patient, keep learning, and wait for the right moment.

And what could be better than starting a new project to kick off the year? 

## Working application

Check out the **live web demo** -> _coming soon_ 


<table>
  <tr>
    <th>Screen</th>
    <th>Preview</th>
    <th>Screen</th>
    <th>Preview</th>
  </tr>
  <tr>
    <td>Begin Screen</td>
    <td><img src="media/images/begin_screen.png" width="300"></td>

  </tr>
  <tr>
    <td>Home Screen</td>
    <td><img src="media/images/home_screen.jpeg" width="300"></td>
    <td>Movie Screen</td>
    <td><img src="media/images/movie_screen.jpeg" width="300"></td>
  </tr>
  <tr>
    <td>Login Screen</td>
    <td><img src="media/images/login_screen.jpeg" width="300"></td>
    <td>Register Screen</td>
    <td><img src="media/images/register_screen.jpeg" width="300"></td>
  </tr>
  </tr>
    <tr>
    <td>All Movie Screen</td>
    <td><img src="media/images/all_movie_screen.jpeg" width="300"></td>
    <td>About Screen</td>
    <td><img src="media/images/about_screen.jpeg" width="300"></td>
  </tr>
  <tr>
    <td>Booking Time</td>
    <td><img src="media/images/booking_time.jpeg" width="300"></td>
    <td>Booking Seat Type</td>
    <td><img src="media/images/booking_seat_type.jpeg" width="300"></td>
  </tr>
  <tr>
    <td>Booking Slot</td>
    <td><img src="media/images/booking_slot.jpg" width="300"></td>
    <td>Tickets Screen</td>
    <td><img src="media/images/tickets_screen.jpg" width="300"></td>
  </tr>
</table>


## 🎬 Cinema Booking

### What Cinema Booking ?

Cinema Booking is an application that helps users search for and book movie tickets at cinemas in Hanoi. The app offers a user-friendly and cinematic interface, quick operations, and a convenient ticket-booking experience.

It leverages Flutter Clean Architecture and Flutter BLoC, ensuring a well-structured and scalable design that facilitates future growth, comprehensive testing, and efficient QA processes. That also makes it easy to develop hard-to-reach UseCase in the future

### Cinema Booking components

This is the collection of components that I developer for [Cinema Booking](https://github.com/ChunhThanhDe/cinema-booking), includes:

- [x] Splash and Get Start (#8 feat screen splash) (#10 feat get-start welcome screen)
- [x] Login (#19 feat login screen)
- [x] Home Main (#20 feat home screen)
- [x] Movie Detail (#25 feat detail movie screen)
- [x] Search All Movie (#28 feat all movie screen)
- [x] Booking Tickets Movie (#33 feat booking movie tickets screen)
- [x] Tickets hold (#38 feat screen tickets hold)
- [x] Mock API Postman for RestAPI

#### More to come... 

- [ ] Payment Screen
- [ ] Search All Cinema in Hanoi
- [ ] Crawl data from Cinema Website
- [ ] IOS version
- { } Web version

Check out the **Cinema Booking roadmap** -> [#43](https://github.com/ChunhThanhDe/cinema-booking/issues/43)

TODO: Demo

## Support 💖

If you like my work, feel free to:

- ⭐ Star this repository to show your support! 🚀
- [![Tweet](https://img.shields.io/twitter/url/http/shields.io.svg?style=social)][tweet] about Cinema Booking
- <a title="Thanks for your support!" href="https://www.buymeacoffee.com/chunhthanhde" target="_blank"><img src="https://res.cloudinary.com/dvujyxh7e/image/upload/c_thumb,w_140,g_face/v1596378474/default-orange_uthxgz.jpg" alt="Buy Me A Coffee"></a>

Your support means a lot! Thank you for stopping by and contributing to the project. 🎬🍿

[tweet]: https://twitter.com/intent/tweet?url=https%3A%2F%2Fgithub.com%2Fchunhthanhde%2Fcinema-booking&text=Check%20out%20this%20awesome%20Cinema%20Booking%20app%20built%20with%20Flutter!&hashtags=Flutter,Firebase,Dart

## Who is it for 🤷‍♀️

I have been working with Flutter and Java for about three years. I built cool stuff at [VNPT Technology][zyllem] but most of them are system applications based on AOSP source code and are under security contracts, making it difficult to showcase them..

This is a showcase user-facing application that I built in my spare time to expand my experience in application development and explore various technologies and new libraries I wanted to try, such as `Firebase`, `Google Maps`, `Payment`,... and more.

There are many Flutter examples on the web but most of them are way too simple. I like to think that this codebase contains enough complexity to offer valuable insights to **Flutter developers of all skill levels** while still being _relatively_ easy to understand.

---

This piece of work is also part of my technical series [Flutter-Journey](https://github.com/Flutter-Journey), which aims to empower developers to **build and scale their own Flutter applications**. My desire is to advocate and grow the Flutter developer community in Vietnam.


## Tech stack 📦

| Category | Library | Description | Icon |
|----------|---------|-------------|------|
| **Framework** | [Flutter](https://github.com/flutter/flutter) | The UI framework powering the application. | ![Flutter](https://avatars.githubusercontent.com/u/14101776?s=200&v=4) |
| **Language** | [Dart](https://github.com/dart-lang/sdk) | The primary language for Flutter development. | ![Dart](https://avatars.githubusercontent.com/u/1609975?s=200&v=4) |
| **State Management** | [Flutter BLoC](https://github.com/felangel/bloc) | Manages state and business logic efficiently. | ![BLoC](https://raw.githubusercontent.com/felangel/bloc/master/docs/assets/logo_full.png) |
|  | [Hydrated BLoC](https://github.com/felangel/hydrated_bloc) | Supports automatic state persistence. | ![Hydrated BLoC](https://raw.githubusercontent.com/felangel/bloc/master/docs/assets/hydrated_bloc_logo_full.png) |
|  | [Equatable](https://github.com/felangel/equatable) | Simplifies object comparison. | ![Equatable](https://avatars.githubusercontent.com/u/43749712?s=200&v=4) |
| **Authentication** | [Firebase Auth](https://github.com/firebase/flutterfire) | Handles user authentication. | ![Firebase](https://firebase.google.com/downloads/brand-guidelines/SVG/logo-logomark.svg) |
|  | [Google Sign-In](https://github.com/flutter/plugins/tree/main/packages/google_sign_in) | Enables login via Google accounts. | ![Google](https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Google_%22G%22_Logo.svg/200px-Google_%22G%22_Logo.svg.png) |
| **Database & Storage** | [Cloud Firestore](https://github.com/firebase/flutterfire) | Provides a NoSQL real-time database. | ![Firestore](https://firebase.google.com/downloads/brand-guidelines/SVG/logo-logomark.svg) |
|  | [Shared Preferences](https://github.com/flutter/plugins/tree/main/packages/shared_preferences) | Stores lightweight user preferences. | ![Shared Preferences](https://upload.wikimedia.org/wikipedia/commons/6/6a/Android_robot.svg) |
|  | [Sqflite](https://github.com/tekartik/sqflite) | Local SQLite database for persistent data. | ![SQLite](https://upload.wikimedia.org/wikipedia/commons/3/38/SQLite370.svg) |
| **Networking & API** | [Dio](https://github.com/cfug/dio) | A powerful HTTP client for API requests. | ![Dio](https://raw.githubusercontent.com/flutterchina/dio/master/docs/logo.png) |
|  | [Retrofit](https://github.com/trevorwang/retrofit.dart) | Simplifies API endpoint definitions with annotations. | ![Retrofit](https://avatars.githubusercontent.com/u/23281642?s=200&v=4) |
| **Navigation** | [Go Router](https://github.com/flutter/packages/tree/main/packages/go_router) | A declarative, flexible navigation system. | ![Go Router](https://raw.githubusercontent.com/flutter/packages/main/packages/go_router/doc/go_router_logo.png) |
| **UI Effects** | [Shimmer](https://github.com/hnvn/flutter_shimmer) | Adds skeleton loading effects for better UX. | ![Shimmer](https://pub.dev/static/img/pub-dev-logo.svg) |
|  | [Carousel Slider](https://github.com/serenader2014/flutter_carousel_slider) | Creates beautiful image sliders. | ![Carousel](https://pub.dev/static/img/pub-dev-logo.svg) |
|  | [Dotted Border](https://github.com/letsar/flutter_dotted_border) | Enhances UI with dotted borders. | ![Dotted Border](https://pub.dev/static/img/pub-dev-logo.svg) |
| **Video & Multimedia** | [YouTube Player Flutter](https://github.com/sarbagyastha/youtube_player_flutter) | Embeds and plays YouTube videos (e.g., movie trailers). | ![YouTube](https://upload.wikimedia.org/wikipedia/commons/b/b8/YouTube_Logo_2017.svg) |
| **Google Maps** | [Google Maps Flutter](https://github.com/flutter/plugins/tree/main/packages/google_maps_flutter) | Displays cinema locations on maps. | ![Google Maps](https://upload.wikimedia.org/wikipedia/commons/6/69/Google_Maps_icon_%282020%29.svg) |
| **JSON Parsing** | [Json Serializable](https://github.com/google/json_serializable.dart) | Automates JSON model generation. | ![JSON](https://upload.wikimedia.org/wikipedia/commons/c/c9/JSON_vector_logo.svg) |
|  | [Build Runner](https://github.com/dart-lang/build) | Generates code for models and API interactions. | ![Build Runner](https://pub.dev/static/img/pub-dev-logo.svg) |
| **Immutability** | [Freezed](https://github.com/rrousselGit/freezed) | Helps in building immutable models. | ![Freezed](https://pub.dev/static/img/pub-dev-logo.svg) |
| **Localization** | [Intl](https://github.com/dart-lang/intl) | Formats dates, numbers, and supports localization. | ![Intl](https://pub.dev/static/img/pub-dev-logo.svg) |
| **SVG Support** | [Flutter SVG](https://github.com/dnfield/flutter_svg) | Enables rendering of vector graphics (SVG). | ![SVG](https://upload.wikimedia.org/wikipedia/commons/4/4b/SVG_Logo.svg) |
| **File System** | [Path Provider](https://github.com/flutter/plugins/tree/main/packages/path_provider) | Provides system paths for file storage. | ![Path Provider](https://pub.dev/static/img/pub-dev-logo.svg) |
| **Code Quality** | [Flutter Lints](https://github.com/flutter/packages/tree/main/packages/flutter_lints) | Enforces best practices and coding standards. | ![Lints](https://pub.dev/static/img/pub-dev-logo.svg) |
| **App Icons** | [Flutter Launcher Icons](https://github.com/fluttercommunity/flutter_launcher_icons) | Generates and manages app icons. | ![Icons](https://pub.dev/static/img/pub-dev-logo.svg) |
| **API Code Generator** | [Retrofit Generator](https://github.com/trevorwang/retrofit.dart) | Auto-generates API clients for Retrofit. | ![Retrofit](https://avatars.githubusercontent.com/u/23281642?s=200&v=4) |

This stack ensures **Cinema Booking** is well-optimized for **scalability, seamless API integration, and an excellent user experience.** 🚀🎬


## High level design

