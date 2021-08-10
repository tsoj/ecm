import
    ecm,
    times

type
    ComponentA = object
        u: uint64
    ComponentB = object
        f: float64
    ComponentD = object
        u: uint64
    ComponentE = object
        u: uint64
    ComponentF = object
        u: uint64
    ComponentG = object
        u: uint64
    ComponentH = object
        u: uint64
    ComponentI = object
        u: uint64
    ComponentJ = object
        u: uint64
    ComponentK = object
        u: uint64

proc benchmark(numEntities = 1_000_000) =
    block:
        var ecm: EntityComponentManager
        block:
            let start = now()
            for i in 0..<numEntities:
                discard ecm.addEntity()
            echo(
                "Create ", numEntities, " entities: ",
                (now() - start).inMicroseconds.float / 1000_000.0, "s"
            )
        block:
            let start = now()
            var removeQueue: seq[Entity]
            for entity in ecm.iterAll:
                removeQueue.add entity
            for i in removeQueue:
                ecm.remove(i)
            echo(
                "Remove ", numEntities, " entities: ",
                (now() - start).inMicroseconds.float / 1000_000.0, "s"
            )
        block:
            for i in 0..<numEntities:
                let entity = ecm.addEntity()
                ecm.add(entity, ComponentA(u: 5))
                ecm.get(entity, ComponentA).u = 50
            let start = now()
            for entity in ecm.iter(ComponentA):
                doAssert ecm.get(entity, ComponentA).u == 50
            echo(
                "Iterating over ", numEntities, " entities, one component: ",
                (now() - start).inMicroseconds.float / 1000_000.0, "s"
            )
    block:
        var ecm: EntityComponentManager
        for i in 0..<numEntities:
            let entity = ecm.addEntity()
            ecm.add(entity, ComponentA(u: 5))
            ecm.get(entity, ComponentA).u = 50
            ecm.add(entity, ComponentB(f: 1.0))
            ecm.get(entity, ComponentB).f = 60.0
        let start = now()
        for entity in ecm.iter(ComponentA, ComponentB):
            doAssert ecm.get(entity, ComponentA).u == 50
            doAssert ecm.get(entity, ComponentB).f == 60.0
        echo(
            "Iterating over ", numEntities, " entities, two components: ",
            (now() - start).inMicroseconds.float / 1000_000.0, "s"
        )
    block:
        var ecm: EntityComponentManager
        for i in 0..<numEntities:
            let entity = ecm.addEntity()
            ecm.add(entity, ComponentA(u: 5))
            ecm.get(entity, ComponentA).u = 50
            if (i mod 2) == 0:
                ecm.add(entity, ComponentB(f: 1.0))
                ecm.get(entity, ComponentB).f = 60.0
        let start = now()
        for entity in ecm.iter(ComponentA, ComponentB):
            doAssert ecm.get(entity, ComponentA).u == 50
            doAssert ecm.get(entity, ComponentB).f == 60.0
        echo(
            "Iterating over ", numEntities, " entities, two components, half of the entities have all the components: ",
            (now() - start).inMicroseconds.float / 1000_000.0, "s"
        )    
    block:
        var ecm: EntityComponentManager
        for i in 0..<numEntities:
            let entity = ecm.addEntity()
            ecm.add(entity, ComponentA(u: 5))
            ecm.get(entity, ComponentA).u = 50
            if i == numEntities div 2:
                ecm.add(entity, ComponentB(f: 1.0))
                ecm.get(entity, ComponentB).f = 60.0
        let start = now()
        for entity in ecm.iter(ComponentA, ComponentB):
            doAssert ecm.get(entity, ComponentA).u == 50
            doAssert ecm.get(entity, ComponentB).f == 60.0
        echo(
            "Iterating over ", numEntities, " entities, two components, only one entity has all the components: ",
            (now() - start).inMicroseconds.float / 1000_000.0, "s"
        )
    block:
        var ecm: EntityComponentManager
        for i in 0..<numEntities:
            let entity = ecm.addEntity()
            ecm.add(entity, ComponentA(u: 5))
            ecm.add(entity, ComponentB(f: 1.0))
            ecm.add(entity, ComponentD(u: 0))
            ecm.add(entity, ComponentE(u: 2))
            ecm.add(entity, ComponentF(u: 1))

            ecm.get(entity, ComponentA).u = 50
            ecm.get(entity, ComponentB).f = 60.0
            ecm.get(entity, ComponentD).u = 100
            ecm.get(entity, ComponentE).u = 101
            ecm.get(entity, ComponentF).u = 102
        let start = now()
        for entity in ecm.iter(ComponentA, ComponentB, ComponentD, ComponentE, ComponentF):
            doAssert ecm.get(entity, ComponentA).u == 50
            doAssert ecm.get(entity, ComponentB).f == 60.0
            doAssert ecm.get(entity, ComponentD).u == 100
            doAssert ecm.get(entity, ComponentE).u == 101
            doAssert ecm.get(entity, ComponentF).u == 102
        echo(
            "Iterating over ", numEntities, " entities, five components: ",
            (now() - start).inMicroseconds.float / 1000_000.0, "s"
        )
    block:
        var ecm: EntityComponentManager
        for i in 0..<numEntities:
            let entity = ecm.addEntity()
            ecm.add(entity, ComponentA(u: 5))
            ecm.add(entity, ComponentB(f: 1.0))
            ecm.add(entity, ComponentD(u: 0))
            ecm.add(entity, ComponentE(u: 1))
            ecm.add(entity, ComponentF(u: 2))
            ecm.add(entity, ComponentG(u: 3))
            ecm.add(entity, ComponentH(u: 4))
            ecm.add(entity, ComponentI(u: 5))
            ecm.add(entity, ComponentJ(u: 6))
            ecm.add(entity, ComponentK(u: 7))

            ecm.get(entity, ComponentA).u = 50
            ecm.get(entity, ComponentB).f = 60.0
            ecm.get(entity, ComponentD).u = 100
            ecm.get(entity, ComponentE).u = 101
            ecm.get(entity, ComponentF).u = 102
            ecm.get(entity, ComponentG).u = 103
            ecm.get(entity, ComponentH).u = 104
            ecm.get(entity, ComponentI).u = 105
            ecm.get(entity, ComponentJ).u = 106
            ecm.get(entity, ComponentK).u = 107
        let start = now()
        for entity in ecm.iter(
            ComponentA,
            ComponentB,
            ComponentD,
            ComponentE,
            ComponentF,
            ComponentG,
            ComponentH,
            ComponentI,
            ComponentJ,
            ComponentK
        ):
            doAssert ecm.get(entity, ComponentA).u == 50
            doAssert ecm.get(entity, ComponentB).f == 60.0
            doAssert ecm.get(entity, ComponentD).u == 100
            doAssert ecm.get(entity, ComponentE).u == 101
            doAssert ecm.get(entity, ComponentF).u == 102
            doAssert ecm.get(entity, ComponentG).u == 103
            doAssert ecm.get(entity, ComponentH).u == 104
            doAssert ecm.get(entity, ComponentI).u == 105
            doAssert ecm.get(entity, ComponentJ).u == 106
            doAssert ecm.get(entity, ComponentK).u == 107
        echo(
            "Iterating over ", numEntities, " entities, ten components: ",
            (now() - start).inMicroseconds.float / 1000_000.0, "s"
        )    
    block:
        var ecm: EntityComponentManager
        for i in 0..<numEntities:
            let entity = ecm.addEntity()
            ecm.add(entity, ComponentA(u: 5))
            ecm.add(entity, ComponentB(f: 1.0))
            ecm.add(entity, ComponentD(u: 0))
            ecm.add(entity, ComponentE(u: 1))
            ecm.add(entity, ComponentF(u: 2))
            ecm.add(entity, ComponentG(u: 3))
            ecm.add(entity, ComponentH(u: 4))
            ecm.add(entity, ComponentI(u: 5))
            ecm.add(entity, ComponentJ(u: 6))

            ecm.get(entity, ComponentA).u = 50
            ecm.get(entity, ComponentB).f = 60.0
            ecm.get(entity, ComponentD).u = 100
            ecm.get(entity, ComponentE).u = 101
            ecm.get(entity, ComponentF).u = 102
            ecm.get(entity, ComponentG).u = 103
            ecm.get(entity, ComponentH).u = 104
            ecm.get(entity, ComponentI).u = 105
            ecm.get(entity, ComponentJ).u = 106

            if (i mod 2) == 0:
                ecm.add(entity, ComponentK(u: 7))
                ecm.get(entity, ComponentK).u = 107
        let start = now()
        for entity in ecm.iter(
            ComponentA,
            ComponentB,
            ComponentD,
            ComponentE,
            ComponentF,
            ComponentG,
            ComponentH,
            ComponentI,
            ComponentJ,
            ComponentK
        ):
            doAssert ecm.get(entity, ComponentA).u == 50
            doAssert ecm.get(entity, ComponentB).f == 60.0
            doAssert ecm.get(entity, ComponentD).u == 100
            doAssert ecm.get(entity, ComponentE).u == 101
            doAssert ecm.get(entity, ComponentF).u == 102
            doAssert ecm.get(entity, ComponentG).u == 103
            doAssert ecm.get(entity, ComponentH).u == 104
            doAssert ecm.get(entity, ComponentI).u == 105
            doAssert ecm.get(entity, ComponentJ).u == 106
            doAssert ecm.get(entity, ComponentK).u == 107
        echo(
            "Iterating over ", numEntities, " entities, ten components, half of the entities have all the components: ",
            (now() - start).inMicroseconds.float / 1000_000.0, "s"
        )
    block:
        var ecm: EntityComponentManager
        for i in 0..<numEntities:
            let entity = ecm.addEntity()
            ecm.add(entity, ComponentA(u: 5))
            ecm.add(entity, ComponentB(f: 1.0))
            ecm.add(entity, ComponentD(u: 0))
            ecm.add(entity, ComponentE(u: 1))
            ecm.add(entity, ComponentF(u: 2))
            ecm.add(entity, ComponentG(u: 3))
            ecm.add(entity, ComponentH(u: 4))
            ecm.add(entity, ComponentI(u: 5))
            ecm.add(entity, ComponentJ(u: 6))

            ecm.get(entity, ComponentA).u = 50
            ecm.get(entity, ComponentB).f = 60.0
            ecm.get(entity, ComponentD).u = 100
            ecm.get(entity, ComponentE).u = 101
            ecm.get(entity, ComponentF).u = 102
            ecm.get(entity, ComponentG).u = 103
            ecm.get(entity, ComponentH).u = 104
            ecm.get(entity, ComponentI).u = 105
            ecm.get(entity, ComponentJ).u = 106

            if i == numEntities div 2:
                ecm.add(entity, ComponentK(u: 7))
                ecm.get(entity, ComponentK).u = 107
        let start = now()
        for entity in ecm.iter(
            ComponentA,
            ComponentB,
            ComponentD,
            ComponentE,
            ComponentF,
            ComponentG,
            ComponentH,
            ComponentI,
            ComponentJ,
            ComponentK
        ):
            doAssert ecm.get(entity, ComponentA).u == 50
            doAssert ecm.get(entity, ComponentB).f == 60.0
            doAssert ecm.get(entity, ComponentD).u == 100
            doAssert ecm.get(entity, ComponentE).u == 101
            doAssert ecm.get(entity, ComponentF).u == 102
            doAssert ecm.get(entity, ComponentG).u == 103
            doAssert ecm.get(entity, ComponentH).u == 104
            doAssert ecm.get(entity, ComponentI).u == 105
            doAssert ecm.get(entity, ComponentJ).u == 106
            doAssert ecm.get(entity, ComponentK).u == 107
        echo(
            "Iterating over ", numEntities, " entities, ten components, only one entity has all the components: ",
            (now() - start).inMicroseconds.float / 1000_000.0, "s"
        )

when isMainModule:
    benchmark()
