# ECM
## Entity Component Manager in Nim
-----------------
### Create an entity
```nim
import ecm

proc main() =
    var ecm: EntityComponentManager
    let entity: Entity = ecm.addEntity()
```
`Entity` is a unique ID for each entity. It is a `distinct int`, but you can do `==`,`<`,`>`, and `$`.

### Remove an entity
```nim
ecm.remove(entity)
```

### Add a component to an entity
```nim
type
    Small = object
        a: int
    Big = object
        a: array[1_000_000, float]
ecm.add(entity, Small(a: 123))
ecm.add(entity, new Big)
```
`tuple` as component type may not work. If you really want `tuple` as component type, you can use it in an object wrapper.

Large but rare objects should be stored as a `ref` in the entity component manager. Otherwise a lot of memory would be wasted.

### Remove a component
```nim
ecm.remove(entity, Small)
```

### Get a component
```nim
echo ecm.get(entity, Small)
echo ecm[entity, Small]
```

### Check if entity exists and has components
```nim
if ecm.has(entity, (Small, ref Big)):
    echo entity, " has 'Small' and 'ref Big'"

elif ecm.has(entity, ref Big):
    echo entity, " has 'ref Big'"

elif ecm.has(entity):
    echo entity, " exists"
```

### Loop over entities with components
```nim
for entity in ecm.iterAll():
    doAssert ecm.has(entity)

for entity in ecm.iter(Small, ref Big):
    doAssert ecm.has(entity, (Small, ref Big))
```

### Do something for each entity with given Components
```nim
forEach(ecm, s: Small, b: ref Big):
    b[].a[4] = s.a.float

for entity in ecm.iter(Small, ref Big):
    doAssert ecm[entity, ref Big][].a[4] == ecm[entity, Small].a.float
```

Take a look at `demo.nim` for a simple program featuring all these functions.



