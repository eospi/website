---
title: Use themes to share colors and font styles
short-title: Themes
description: How to share colors and font styles throughout an app using Themes.
prev:
  title: Update the UI based on orientation
  path: /docs/cookbook/design/orientation
next:
  title: Use custom fonts
  path: /docs/cookbook/design/fonts
---

To share colors and font styles throughout an app, use themes.
You can either define app-wide themes, or use `Theme` widgets
that define the colors and font styles for a particular part
of the application. In fact,
app-wide themes are just `Theme` widgets created at
the root of an app by the `MaterialApp`.

After defining a Theme, use it within your own widgets. Flutter's
Material widgets also use your Theme to set the background
colors and font styles for AppBars, Buttons, Checkboxes, and more.

## Creating an app theme

To share a Theme across an entire app, provide a
[`ThemeData`]({{site.api}}/flutter/material/ThemeData-class.html)
to the `MaterialApp` constructor.

If no `theme` is provided, Flutter creates a default theme for you.

<!-- skip -->
```dart
MaterialApp(
  title: title,
  theme: ThemeData(
    // Define the default brightness and colors.
    brightness: Brightness.dark,
    primaryColor: Colors.lightBlue[800],
    accentColor: Colors.cyan[600],
    
    // Define the default font family.
    fontFamily: 'Montserrat',
    
    // Define the default TextTheme. Use this to specify the default
    // text styling for headlines, titles, bodies of text, and more.
    textTheme: TextTheme(
      headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
      body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
    ),
  )
);
```

See the [ThemeData]({{site.api}}/flutter/material/ThemeData-class.html)
documentation to see all of the colors and fonts you can define.

## Themes for part of an application

To override the app-wide theme in part of an application,
wrap a section of the app in a `Theme` widget.

There are two ways to approach this: creating a unique `ThemeData`,
or extending the parent theme.

### Creating unique `ThemeData`

If you don't want to inherit any application colors or font styles,
create a `ThemeData()` instance and pass that to the `Theme` widget.

<!-- skip -->
```dart
Theme(
  // Create a unique theme with "ThemeData"
  data: ThemeData(
    accentColor: Colors.yellow,
  ),
  child: FloatingActionButton(
    onPressed: () {},
    child: Icon(Icons.add),
  ),
);
```

### Extending the parent theme

Rather than overriding everything, it often makes sense to extend the parent
theme. You can handle this by using the
[`copyWith()`]({{site.api}}/flutter/material/ThemeData/copyWith.html)
method.

<!-- skip -->
```dart
Theme(
  // Find and extend the parent theme using "copyWith". See the next
  // section for more info on `Theme.of`.
  data: Theme.of(context).copyWith(accentColor: Colors.yellow),
  child: FloatingActionButton(
    onPressed: null,
    child: Icon(Icons.add),
  ),
);
```

## Using a Theme

Now that you've defined a theme, use it within the widgets' `build()`
methods by using the `Theme.of(context)` method.

The `Theme.of(context)` method looks up the widget tree and returns
the nearest `Theme` in the tree. If you have a standalone
`Theme` defined above your widget, that's returned.
If not, the app's theme is returned.

In fact, the `FloatingActionButton` uses this technique to find the
`accentColor`.

<!-- skip -->
```dart
Container(
  color: Theme.of(context).accentColor,
  child: Text(
    'Text with a background color',
    style: Theme.of(context).textTheme.title,
  ),
);
```

## Complete example

```dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appName = 'Custom Themes';

    return MaterialApp(
      title: appName,
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.dark,
        primaryColor: Colors.lightBlue[800],
        accentColor: Colors.cyan[600],

        // Define the default font family.
        fontFamily: 'Montserrat',

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      home: MyHomePage(
        title: appName,
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({Key key, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Container(
          color: Theme.of(context).accentColor,
          child: Text(
            'Text with a background color',
            style: Theme.of(context).textTheme.title,
          ),
        ),
      ),
      floatingActionButton: Theme(
        data: Theme.of(context).copyWith(
          colorScheme:
              Theme.of(context).colorScheme.copyWith(secondary: Colors.yellow),
        ),
        child: FloatingActionButton(
          onPressed: null,
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
```

![Themes Demo](/images/cookbook/themes.png){:.site-mobile-screenshot}
