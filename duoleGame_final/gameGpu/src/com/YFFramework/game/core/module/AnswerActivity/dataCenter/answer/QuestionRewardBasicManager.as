package com.YFFramework.game.core.module.AnswerActivity.dataCenter.answer
{
	import flash.utils.Dictionary;

	public class QuestionRewardBasicManager
	{
		private static var _instance:QuestionRewardBasicManager;
		private var _dict:Dictionary;
		public function QuestionRewardBasicManager()
		{
			_dict=new Dictionary();
		}
		public static function get Instance():QuestionRewardBasicManager
		{
			if(_instance==null)_instance=new QuestionRewardBasicManager();
			return _instance;
		}
		public  function cacheData(jsonData:Object):void
		{
			var question_RewardBasicVo:QuestionRewardBasicVo;
			for (var id:String in jsonData)
			{
				question_RewardBasicVo=new QuestionRewardBasicVo();
				question_RewardBasicVo.item_number=jsonData[id].item_number;
				question_RewardBasicVo.right_number=jsonData[id].right_number;
				question_RewardBasicVo.item_id=jsonData[id].item_id;
				_dict[question_RewardBasicVo.right_number]=question_RewardBasicVo;
			}
		}
		public function getQuestionRewardBasicVo(right_number:int):QuestionRewardBasicVo
		{
			return _dict[right_number];
		}
	}
}