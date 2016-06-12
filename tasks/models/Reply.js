var mongoose = require('mongoose')

var ReplySchema = new mongoose.Schema({
	reply: {type:String, default:''},
	from: {type:String, default:''},
	to: {type:String, default:''},
	post: {type:String, default:''},
	timestamp: {type:Date, default:Date.now}
})

module.exports = mongoose.model('ReplySchema', ReplySchema)