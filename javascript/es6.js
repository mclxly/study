    function* echo(text, delay = 0) {
        const caller = yield;
        setTimeout(() => caller.success(text), delay);
    }

        run(function* echoes() {
        console.log(yield echo('this'));
        console.log(yield echo('is'));
        console.log(yield echo('a test'));
    });