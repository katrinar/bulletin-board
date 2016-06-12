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
