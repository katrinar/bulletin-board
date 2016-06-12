var express = require('express')
var router = express.Router()
var Post = require('../models/Post')
var Reply = require('../models/Reply')

router.get('/:resource', function(req, res, next) {
	var resource = req.params.resource

	if (resource == 'reply'){

		Reply.find(req.query, function(err, results){
			if (err){
				res.json({
					confirmation: 'fail',
					message: err
				})
				return
			}

			res.json({
				confirmation: 'success',
				results: results
			})
			return
		})

		return 	
	}

	
	if (resource == 'post'){

		Post.find(req.query, function(err, results){
			if (err){
				res.json({
					confirmation: 'fail',
					message: err
				})
				return
			}

			res.json({
				confirmation: 'success',
				results: results
			})
			return
		})

		return 	
	}
})

router.post('/:resource', function(req, res, next) {
	var resource = req.params.resource

	if (resource == 'reply'){ //reply to a post


		var params = req.body

		var sendgrid = require('sendgrid')(process.env.SENDGRID_USERNAME, process.env.SENDGRID_PASSWORD);

		var replyMsg = params['reply'] + ". This came from " + params['from']
		sendgrid.send({
			to: params['to'],
			from: 'karodriguez8@gmail.com',
			subject: 'Someone Replied to your post!',
			text: replyMsg
		}, function(err){

		})

		Reply.create(req.body, function(err, result){
			if (err){
				res.json({
					confirmation: 'fail',
					message: err
				})
				return
			}

			res.json({
				confirmation: 'success',
				result: result
			})
			return
		})
	}

	console.log('POST: '+JSON.stringify(req.body))
	if (req.body['geo[]'] != null)
		req.body['geo'] = req.body['geo[]'] //Swift sends back 'geo[]'

	if (resource == 'post'){
		Post.create(req.body, function(err, result){
			if (err){
				res.json({
					confirmation: 'fail',
					message: err
				})
				return
			}

			res.json({
				confirmation: 'success',
				result: result
			})
			return
		})
		
	}
})

module.exports = router
