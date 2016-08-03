Package.describe({
  name: 'peerlibrary:blaze-layout-component',
  summary: "A simple Blaze Component for use with Flow Router's layout manager",
  version: '0.1.1',
  git: 'https://github.com/peerlibrary/meteor-blaze-layout-component.git'
});

Package.onUse(function (api) {
  api.versionsFrom('METEOR@1.0.3.1');

  // Core dependencies.
  api.use([
    'coffeescript'
  ]);

  // 3rd party dependencies.
  api.use([
    'peerlibrary:blaze-components@0.18.0',
    'kadira:blaze-layout@2.3.0',
    'peerlibrary:computed-field@0.3.1',
    'peerlibrary:assert@0.2.5'
  ]);

  api.export('BlazeLayoutComponent');

  api.addFiles([
    'layout.coffee'
  ]);

  api.addFiles([
    'root.html',
    'root.coffee'
  ], 'client');
});
