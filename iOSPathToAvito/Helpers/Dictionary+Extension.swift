extension Dictionary {
    subscript(i: Int) -> (key: Key, value: Value) {
        return self[index(startIndex, offsetBy: i)]
    }
}
