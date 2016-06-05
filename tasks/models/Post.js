var mongoose = require('mongoose')

var PostSchema = new mongoose.Schema({
	title: {type:String, default:''},
	description: {type:String, default:''},
	email: {type:String, default:''},
	geo: {type: [Number], index: '2d'},
	timestamp: {type:Date, default:Date.now}
})

module.exports = mongoose.model('PostSchema', PostSchema)