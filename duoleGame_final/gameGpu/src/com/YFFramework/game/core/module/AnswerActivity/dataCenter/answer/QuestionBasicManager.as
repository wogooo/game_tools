package com.YFFramework.game.core.module.AnswerActivity.dataCenter.answer
{
	import flash.utils.Dictionary;

	public class QuestionBasicManager
	{
		private static var _instance:QuestionBasicManager;
		private var _dict:Dictionary;
		public function QuestionBasicManager()
		{
			_dict=new Dictionary();
		}
		public static function get Instance():QuestionBasicManager
		{
			if(_instance==null)_instance=new QuestionBasicManager();
			return _instance;
		}
		public  function cacheData(jsonData:Object):void
		{
			var questionBasicVo:QuestionBasicVo;
			for (var id:String in jsonData)
			{
				questionBasicVo=new QuestionBasicVo();
				questionBasicVo.answer3=jsonData[id].answer3;
				questionBasicVo.question_id=jsonData[id].question_id;
				questionBasicVo.answer4=jsonData[id].answer4;
				questionBasicVo.answer2=jsonData[id].answer2;
				questionBasicVo.answer1=jsonData[id].answer1;
				questionBasicVo.context=jsonData[id].context;
				_dict[questionBasicVo.question_id]=questionBasicVo;
			}
		}
		public function getQuestionBasicVo(question_id:int):QuestionBasicVo
		{
			return _dict[question_id];
		}
	}
}