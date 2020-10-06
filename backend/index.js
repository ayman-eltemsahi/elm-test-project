const app = require('./app');
const port = 678;

app.listen(port, () => {
    console.log(`server started listening on port ${port}`);
});
