resources = ["shells"]

for resource in resources

  describe resource + ' GET/PUT/POST/DELETE middleware', () ->
    tests = require('../../resources/'+resource+'/'+"tests")

    for test in tests
      it resource + test.name, test.test

