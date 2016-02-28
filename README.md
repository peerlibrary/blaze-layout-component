Blaze Layout Component
======================

A simple [Blaze Component](https://github.com/peerlibrary/meteor-blaze-components) for use with
[Flow Router](https://github.com/kadirahq/flow-router)'s [layout manager](https://github.com/kadirahq/blaze-layout).

Adding this package to your [Meteor](http://www.meteor.com/) application adds `BlazeLayoutComponent` class
into the global scope. It also configures the root Blaze Component to serve as the root of the components' tree.

Alternatively, you can also use our [fork of Flow Router](https://github.com/peerlibrary/flow-router), which
adds [ignoring links](https://github.com/peerlibrary/flow-router#ignoring-links) feature to it.

Client side only.

Installation
------------

```
meteor add peerlibrary:blaze-layout-component
```

Usage
-----

Define your layout component:

```handlebars
<template name="ColumnsLayoutComponent">
  {{> HeaderComponent}}
  <main>
    <div class="row">
      <div class="first col s4">
        {{> renderFirst}}
      </div>
      <div class="second col s4">
        {{> renderSecond}}
      </div>
      <div class="third col s4">
        {{> renderThird}}
      </div>
    </div>
  </main>
  {{> FooterComponent}}
</template>
```

```javascript
class ColumnsLayoutComponent extends BlazeLayoutComponent {
  renderFirst(parentComponent) {
    this._renderRegion('first', parentComponent);
  }

  renderSecond(parentComponent) {
    this._renderRegion('second', parentComponent);
  }

  renderThird(parentComponent) {
    this._renderRegion('third', parentComponent);
  }
}

ColumnsLayoutComponent.register('ColumnsLayoutComponent');
```

Then you can define a route using this layout:

```javascript
FlowRouter.route('/post/:_id', {
  name: 'Post.display'
  action: function (params, queryParams) {
    BlazeLayout.render('ColumnsLayoutComponent', {
      first: 'FirstComponent',
      second: 'SecondComponent',
      third: 'ThirdComponent'
    });
  }
});
```

Alternatively, you can restrict regions' names to catch possible errors:

```javascript
class ColumnsLayoutComponent extends BlazeLayoutComponent {
  renderFirst(parentComponent) {
    this._renderRegion(this.constructor.REGIONS.FIRST, parentComponent);
  }

  renderSecond(parentComponent) {
    this._renderRegion(this.constructor.REGIONS.SECOND, parentComponent);
  }

  renderThird(parentComponent) {
    this._renderRegion(this.constructor.REGIONS.THIRD, parentComponent);
  }
}

ColumnsLayoutComponent.REGIONS = {
  FIRST: 'first',
  SECOND: 'second',
  THIRD: 'third'
};

ColumnsLayoutComponent.register('ColumnsLayoutComponent');
```

A good pattern to access the `_id` parameter from the URL is something like:

```javascript
class FirstComponent extends BlazeComponent {
  onCreated() {
    super.onCreated();

    this.currentPostId = new ComputedField(() => {
      return FlowRouter.getParam('_id');
    });

    this.autorun((computation) => {
      postId = this.currentPostId();
      if (postId) this.subscribe('Comments', postId);
    });
  }

  comments() {
    return Comments.find({
      'post._id': this.currentPostId()
    });
  }
}

FirstComponent.register('FirstComponent');
```
