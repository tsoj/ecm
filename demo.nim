import ecm

type
    Small = object
        a: int
    Big = object
        a: array[10, float]

proc main() =
    var ecm: EntityComponentManager

    # add entity
    let e1 = ecm.addEntity()

    # add components to entity
    ecm.add(e1, Small(a: 123))
    ecm.add(e1, new Big)

    # remove component from entity
    ecm.remove(e1, Small)

    # check if entity exists
    if ecm.has(e1):
        echo e1, " exists"

    # check if entity exists and has components
    if ecm.has(e1, (Small, ref Big)):
        
        # get component from entity
        echo ecm.get(e1, Small)
        echo ecm[e1, ref Big][]

    # check if entity exists and has single component
    if ecm.has(e1, ref Big):
        echo ecm[e1, ref Big][]

    # loop over entities with given components
    for entity in ecm.iter(Small, ref Big):
        echo ecm[entity, Small]
        echo ecm[entity, ref Big][]

    let e2 = ecm.addEntity()
    ecm.add(e2, Small(a: 456))
    ecm.add(e2, new Big)

    # do this for all entities with components
    # fitting to the arguments
    forEach(ecm, s: Small, b: ref Big):
        b[].a[4] = s.a.float
    
    for entity in ecm.iter(Small, ref Big):
        echo entity, ":"
        echo "    ", ecm[entity, Small]
        echo "    ", ecm[entity, ref Big][]

    # remove entity
    ecm.remove(e1)

    # loop over all entities
    for entity in ecm.iterAll():
        echo entity, " exists!"

when isMainModule:
    main()