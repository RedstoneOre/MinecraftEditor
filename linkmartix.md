## Types
str: simple str
iter: "$originID $offset" - for vertical
- the point $originID+($offset, 0)
- no other pts between the 2 pts
- $offset must greater||equal than 0
disit: "$originID $distance" - for horizontal
- $distance right from $originID
- no other pts between the 2 pts
## Parts
`fc[id]`: value - str
`fcn[id]`: next - disit
`fcp[id]``: prev - disit
`fcu[id]`: up - iter
`fcd[id]`: down - iter
## Algorithm

### FindOffset <originIter -> oit>


### AddNode <originID -> oid> <right_distance -> rdis>:

