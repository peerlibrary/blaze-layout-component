class BlazeLayoutComponent extends BlazeComponent
  onCreated: ->
    super

    @regions = {}

    # If set of regions is restricted, then check them.
    if @constructor.REGIONS
      @autorun (computation) =>
        unknownRegions = _.difference _.keys(@data()), _.values(@constructor.REGIONS)

        throw new Error "Unknown layout region(s) requested: #{unknownRegions.join ', '}." if unknownRegions.length

  # To make it easier to use region values in methods and minimize reactivity.
  _regionToComponentName: (regionName) ->
    if @constructor.REGIONS and regionName not in _.values @constructor.REGIONS
      throw new Error "Unknown layout region '#{regionName}'."

    # Initialize if we are requesting region for the first time.
    @regions[regionName] ?= new ComputedField =>
      # The data context is mapping between region names and region getters.
      @data()?[regionName]?() or null
    ,
      # Referential equality, so that possible component classes are equal.
      (a, b) => a is b

    @regions[regionName]()

  _renderRegion: (regionName, parentComponent) ->
    return null unless regionName

    componentName = @_regionToComponentName regionName

    return null unless componentName

    if _.isString componentName
      component = BlazeComponent.getComponent componentName
    else
      # Otherwise we assume it is already a component.
      component = componentName

    throw new Error "Unknown component '#{componentName}'." unless component

    parentComponent ?= @currentComponent()

    # To force no data context in rendered region component.
    new Blaze.Template =>
      Blaze.With null, =>
        component.renderComponent parentComponent
