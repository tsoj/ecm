import
    ecm,
    strformat,
    math

type
    ComponentA = object
        i: int
    ComponentB = object
        f: float
    ComponentC = ref object
        c: array[10000, char]
    ComponentS = object
        l: int

func newComponentC(): ComponentC =
    result = new ComponentC
    # discard

proc test() =

    for numberEntities in [0, 1, 2, 3, 4, 10, 25, 60, 150, 400, 1_000, 2_000, 5_000, 10_000]:
        var ecm: EntityComponentManager
        for i in 1..numberEntities:
            discard ecm.addEntity()
        
        for entity in ecm.iterAll():
            if (entity.int mod 7) == 0:
                ecm.remove(entity)
                if (entity.int mod 4) != 0:
                    discard ecm.addEntity()
        
        for entity in ecm.iterAll():
            if (entity.int mod 1) == 0:
                ecm.add(entity, ComponentS(l: 5))

                ecm.add(entity, ComponentA(i: "Hello".len))
                ecm.get(entity, ComponentA).i = entity.int
                doAssert ecm.get(entity, ComponentA).i == entity.int

                if (entity.int mod 3) == 1:
                    ecm.remove(entity, ComponentA)
                    ecm.add(entity, ComponentA(i: "Hello".len))
                    ecm.get(entity, ComponentA).i = entity.int
                    doAssert ecm.get(entity, ComponentA).i == entity.int

                if (entity.int mod 5) == 2:
                    doAssert ecm.has(entity, ComponentA)
                    ecm.get(entity, ComponentA).i = entity.int
                    doAssert ecm.get(entity, ComponentA).i == entity.int

            if (entity.int mod 2) == 0:
                ecm.add(entity, ComponentB(f: 0.0))
                ecm.get(entity, ComponentB).f = entity.float /  numberEntities.float
            
            if (entity.int mod 5) == 0:
                ecm.add(entity, newComponentC())
                ecm.get(entity, ComponentC).c[0] = cast[char](entity)

        var removeLater: seq[Entity]
        for entity in ecm.iter(ComponentC):
            if (entity.int mod 3) == 0:
                removeLater.add(entity)
        for entity in removeLater:
            ecm.remove(entity, ComponentC)        
        for entity in ecm.iter(ComponentC):
            if (entity.int mod 3) == 0:
                if (entity.int mod 4) != 0:
                    ecm.add(entity, newComponentC())
                    ecm.get(entity, ComponentC).c[0] = cast[char](entity)

        for entity in ecm.iter(ComponentA):
            doAssert ecm.get(entity, ComponentA).i == entity.int
        
        for entity in ecm.iter(ComponentA):
            if (entity.int mod (numberEntities div 5 + 1)) == 0:
                for entity2 in ecm.iter(ComponentA):
                    if entity2 > entity:
                        doAssert entity2 != entity
                        ecm.get(entity2, ComponentA).i += 1
        

        var firstEntity = Entity.high
        for entity in ecm.iter(ComponentA):
            if firstEntity == Entity.high:
                firstEntity = entity
            var addition = 0
            for i in firstEntity..<entity:
                if (i.int mod (numberEntities div 5 + 1)) == 0 and ecm.has(i, ComponentA):
                    addition += 1
            doAssert entity.int + addition == ecm.get(entity, ComponentA).i

        # TODO: replace stuff1 and stuff3 with forEach

        forEach(ecm, a: ComponentA, b: ComponentB, s: var ComponentS):
            s.l = (a.i + 1) * (19 + a.i) * (if b.f < 0.999: 1 else: 2)

        proc stuff2(ecm: EntityComponentManager) =
            forEach(ecm, a: ComponentA, b: ComponentB, s: ComponentS):
                doAssert s.l == (a.i + 1) * (19 + a.i) * (if b.f < 0.999: 1 else: 2)
        stuff2(ecm)

        for entity in ecm.iter(ComponentA, ComponentB, ComponentS):
            doAssert(
                ecm.get(entity, ComponentS).l ==
                (ecm.get(entity, ComponentA).i + 1) * (19 + ecm.get(entity, ComponentA).i) *
                (if ecm.get(entity, ComponentB).f < 0.999: 1 else: 2)
            )    
    echo "Finished test"

type
    Position = object
        x,y: float
    Mass = object
        m: float
    TimeBomb = ref object
        t: int

proc newTimeBomb(): TimeBomb =
    result = new TimeBomb
    result.t = 1

proc test2() =
    var output: string
    block:
        var ecm: EntityComponentManager
        let
            entity0 = ecm.addEntity()
            entity1 = ecm.addEntity()
            entity2 = ecm.addEntity()
            entity3 = ecm.addEntity()

        ecm.add(entity0, Position(x: 10.0, y: 20.0))
        ecm.add(entity1, Position(x: 5.5, y: 90.5))
        ecm.add(entity2, Position(x: 30.0, y: 15.0))
        ecm.add(entity3, Position(x: 8.0, y: 18.0))

        ecm.add(entity0, Mass(m: 40_000_000.0))
        ecm.add(entity1, Mass(m: 2_000_000.0))
        ecm.add(entity3, Mass(m: 800_000.0))

        ecm.add(entity0, newTimeBomb())

        forEach(ecm, p: Position, m: var Mass):
            if p.x + p.y < 27.5: # this is only true for entity3
                doAssert m.m == ecm.get(entity3, Mass).m
                m.m *= 1000.0

        for entityA in ecm.iter(Position, Mass):
            for entityB in ecm.iter(Position, Mass):
                if entityA < entityB:
                    let
                        dx = ecm.get(entityB, Position).x - ecm.get(entityA,Position).x
                        dy = ecm.get(entityB, Position).y - ecm.get(entityA,Position).y
                        distanceSquared = dx^2 + dy^2
                    let F = 6.67259e-11 * ((ecm.get(entityB, Mass).m * ecm.get(entityA, Mass).m) / distanceSquared)
                    output &= "Force between entity " & $entityA & " and " & $entityB & ": " & fmt"{F:>.3f}" & "\n"
        
        for entity in ecm.iterAll():
            if ecm.has(entity, TimeBomb):
                ecm.remove(entity)
                output &= "Entity " & $entity & " exploded." & "\n"
    block:
        var ecm: EntityComponentManager

        let entity1 = ecm.addEntity()
        ecm.add(entity1, float(0.5))
        ecm.add(entity1, int(2))

        output &= $ecm.has(entity1, (float, int, string)) & "\n"
        output &= $ecm.has(entity1, string) & "\n"
        output &= $ecm.has(entity1, float) & "\n"
        output &= $ecm.has(entity1, (float, int)) & "\n"
        ecm.remove(entity1, int)
        output &=  $ecm.has(entity1, (float, int)) & "\n"
        output &=  $ecm.get(entity1, float) & "\n"
        ecm.get(entity1, float) = 0.6
        output &= $ecm.get(entity1, float) & "\n"

        proc stuff(ecm: EntityComponentManager, entity: Entity) =
            output &= $ecm.get(entity, float) & "\n"

        ecm.stuff(entity1)


        ecm.add(entity1, "hello :D")


        let entity2 = ecm.addEntity()
        ecm.add(entity2, "hello 2")
        ecm.add(entity2, float(2.0))

        let entity3 = ecm.addEntity()
        ecm.add(entity3, "hello 3")
        ecm.add(entity3, int(3))

        let entity4 = ecm.addEntity()
        ecm.add(entity4, float(4.0))
        ecm.add(entity4, int(4))
        ecm.add(entity4, "hello 4")
        ecm.remove(entity4, float)

        let entity5 = ecm.addEntity()
        ecm.add(entity5, "hello 5")
        ecm.add(entity5, float(5.0))

        let entity6 = ecm.addEntity()
        ecm.add(entity6, int(6))
        ecm.add(entity6, float(6.0))

        for entity in ecm.iter(float, string):
            output &= $entity & "\n"

        forEach(ecm, f: var float, s: string):
            output &= $s & "\n"
            f = 10.0

        forEach(ecm, f: float):
            output &= $f & "\n"

        forEach(ecm, f: var float, s: string):
            output &= $s & "\n"
            f = 10.0


        ecm.remove(entity4)

        let entity7 = ecm.addEntity()
        discard ecm.addEntity()
        ecm.remove(entity7)

        for entity in ecm.iterAll():
            output &= $entity & "\n"
    stdout.write(output)
    stdout.flushFile()
    doAssert(
        output ==
        "Force between entity 0 and 1: 1.070\n" &
        "Force between entity 0 and 3: 266903.600\n" &
        "Force between entity 1 and 3: 20.287\n" &
        "Entity 0 exploded.\n" &
        "false\n" &
        "false\n" &
        "true\n" &
        "true\n" &
        "false\n" &
        "0.5\n" &
        "0.6\n" &
        "0.6\n" &
        "0\n" &
        "1\n" &
        "4\n" &
        "hello :D\n" &
        "hello 2\n" &
        "hello 5\n" &
        "10.0\n" &
        "10.0\n" &
        "10.0\n" &
        "6.0\n" &
        "hello :D\n" &
        "hello 2\n" &
        "hello 5\n" &
        "0\n" &
        "1\n" &
        "2\n" &
        "4\n" &
        "5\n" &
        "6\n"
    )

when isMainModule:
    test2()
    test()


            


