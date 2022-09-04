////
////  MockAnyMapper.swift
////  ContributionGraphTests
////
////  Created by Vyacheslav Konopkin on 30.08.2022.
////
//
//import Mockingbird
//
//@testable import ContributionGraph
//
////protocol TestMapper: Mapper where Input == Any, Output == Any {
////    func map(input: Input) -> Output
////}
////
////func mockAnyMapper<Input, Output>() -> AnyMapper<Input, Output> {
////    let m = mock(TestMapper.self)
//////    AnyMapper(wrapped: mock(TestMapper.self))
////}
////
//
//func mockAnyMapper<Input, Output>(_ mock: MockAnyMapper<Input, Output>) -> AnyMapper<Input, Output> {
//    AnyMapper(wrapped: mock)
//}
//
//class MockAnyMapper<Input, Output>: Mapper {
//    let output: Output
//
//    init(output: Output) {
//        self.output = output
//    }
//
//    func map(input: Input) -> Output {
//        return output
//    }
//}
