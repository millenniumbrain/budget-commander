module.exports = {
 entry: './ts/main.ts',
 output: {
   filename: 'public/js/app.js',
   path: __dirname
 },
 module: {
   rules: [
     {
       test: /\.tsx?$/,
       loader: 'ts-loader'
     },
   ]
 },
 resolve: {
   modules: ["node_modules"],
   extensions: [".tsx", ".ts", ".js"]
 },
 devtool: 'inline-source-maps',
};

