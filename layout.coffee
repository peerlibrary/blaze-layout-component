class BlazeLayoutComponent extends BlazeComponent
  onCreated: ->
    super

    # To make it easier to use region values in methods and minimize reactivity.
    @regions = {}
    for region, name of @constructor.REGIONS
      do (name) =>
        @regions[name] = new ComputedField =>
          @data()?[name]?() or null

    @autorun (computation) =>
      unknownRegions = _.difference _.keys(@data()), _.values(@constructor.REGIONS)

      throw new Error "Unknown layout region(s) requested: #{unknownRegions.join ', '}." if unknownRegions.length

  _renderRegion: (regionName, parentComponent) ->
    return null unless regionName

    assert _.has(@regions, regionName), regionName

    componentName = @regions[regionName]()

    return null unless componentName

    component = BlazeComponent.getComponent componentName

    throw new Error "Unknown component '#{componentName}'." unless component

    parentComponent ?= @currentComponent()

    # To force no data context in rendered region component.
    new Blaze.Template =>
      Blaze.With null, =>
        component.renderComponent parentComponent
