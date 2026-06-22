func waitVeryShort() async {
    try? await Task.sleep(for: .milliseconds(.random(in: 100...500)))
}

func waitShort() async {
    try? await Task.sleep(for: .milliseconds(.random(in: 1000...2000)))
}

func waitLong() async {
    try? await Task.sleep(for: .milliseconds(.random(in: 3000...5000)))
}
