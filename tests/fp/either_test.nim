import ../../src/fp/either, unittest, future

{.warning[SmallLshouldNotBeUsed]: off.}

suite "Either ADT":

  let r = 10.rightS
  let l = "Error".left(int)

  test "Basic functions":
    let l1 = Left[int,string](10)
    let l2 = 10.left("")
    let l3 = 10.left(string)
    let r1 = Right[int,string]("test")
    let r2 = "test".right(0)
    let r3 = "test".right(int)

    check: l1 == l2
    check: l1 == l2

    check: r1 == r2
    check: r1 == r3

    check: r1 != l1
    check: r2 != l2

    check: 123.rightE == 123.rightE
    check: 123.rightS == 123.rightS

    check: $l1 == "Left(10)"
    check: $r1 == "Right(test)"
    
  test "Map":
    check: r.map(x => x * 2) == 20.rightS
    check: l.map(x => x * 2) != 20.rightS
    check: l.map(x => x * 2) == l

    check: r.flatMap((x: int) => (x * 2).rightS) == 20.rightS
    check: r.flatMap((x: int) => l) == l

    check: "Value".rightS.map2(10.rightS, (x: string, y: int) => x & $y) == "Value10".rightS
    check: "Error1".left(string).map2(10.rightS, (x: string, y: int) => x & $y) == "Error1".left(string)
    check: "Value".rightS.map2("Error2".left(int), (x: string, y: int) => x & $y) == "Error2".left(string)

  test "Getters":
    check: r.getOrElse(0) == 10
    check: r.getOrElse(() => 0) == 10

    check: l.getOrElse(0) == 0
    check: l.getOrElse(() => 0) == 0

    check: r.orElse(l) == r
    check: r.orElse(() => l) == r
    
    check: l.orElse(r) == r
    check: l.orElse(() => r) == r
    
  test "Safe exceptions":
    check: tryE(() => 2/4) == 0.5.rightE
    check: tryS(() => 2/4) == 0.5.rightS
    {.floatChecks: on.}
    var x = 2.0
    check: tryE(() => x / 0.0).isLeft == true
    check: tryS(() => x / 0.0).isLeft == true
    let f = () => (
      result = 1;
      raise newException(Exception, "Test Error")
    )
    let ex1 = tryS f
    let ex2 = tryE f
    check: ex1.errorMsg == "Test Error"
    check: ex2.errorMsg == "Test Error"