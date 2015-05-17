package com.YFFramework.core.utils
{

	/** @author  yefeng 
	 * 随机获取名称
	 */
    public class RandomName extends Object
    {
        public static const Man:int = 0;
        public static const Woman:int = 1;
        private static var firstNames:Array = ["司马", "欧阳", "端木", "上官", "独孤", "夏侯", "尉迟", "赫连", "皇甫", "公孙", "慕容", "长孙", "宇文", "司徒", "轩辕", "百里", "呼延", "令狐", "诸葛", "南宫", "东方", "西门", "李", "王", "张", "刘", "陈", "杨", "赵", "黄", "周", "胡", "林", "梁", "宋", "郑", "唐", "冯", "董", "程", "曹", "袁", "许", "沈", "曾", "彭", "吕", "蒋", "蔡", "魏", "叶", "杜", "夏", "汪", "田", "方", "石", "熊", "白", "秦", "江", "孟", "龙", "万", "段", "雷", "武", "乔", "洪", "鲁", "葛", "柳", "岳", "梅", "辛", "耿", "关", "苗", "童", "项", "裴", "鲍", "霍", "甘", "景", "包", "柯", "阮", "华", "滕", "穆", "燕", "敖", "冷", "卓", "花", "蓝", "楚", "荆","古"];
        private static var secondMan0:Array = ["峰", "不", "近", "千", "万", "百", "亿", "一", "求", "笑", "双", "凌", "伯", "仲", "叔", "震", "飞", "晓", "昌", "霸", "冲", "志", "留", "九", "子", "立", "小", "云", "文", "安", "博", "才", "光", "弘", "华", "清", "灿", "俊", "凯", "乐", "良", "明", "健", "辉", "天", "星", "永", "英", "真", "修", "义", "嘉", "成", "傲", "欣", "逸", "飘", "凌", "青", "火", "森", "杰", "思", "智", "辰", "元", "夕", "苍", "劲", "巨", "潇", "邪", "尘"];
        private static var secondMan1:Array = ["败", "悔", "南", "宝", "仞", "刀", "斐", "德", "云", "天", "仁", "岳", "宵", "忌", "爵", "权", "敏", "阳", "狂", "冠", "康", "平", "强", "凡", "邦", "福", "歌", "国", "和", "康", "澜", "民", "宁", "然", "顺", "翔", "晏", "宜", "易", "志", "雄", "佑", "斌", "河", "元", "墨", "松", "林", "之", "翔", "竹", "宇", "轩", "荣", "哲", "风", "霜", "山", "炎", "罡", "盛", "睿", "达", "洪", "武", "耀", "磊", "寒", "冰", "潇", "痕", "空"];
        private static var secondWoman0:Array = ["思", "冰", "夜", "痴", "依", "小", "香", "绿", "映", "含", "曼", "春", "醉", "之", "新", "雨", "天", "如", "若", "涵", "亦", "采", "冬", "安", "芷", "绮", "雅", "飞", "又", "寒", "忆", "晓", "乐", "笑", "妙", "元", "碧", "翠", "初", "怀", "幻", "慕", "秋", "语", "觅", "幼", "灵", "傲", "冷", "沛", "念", "水", "紫", "惜", "诗", "青", "雁", "盼", "尔", "以", "雪", "夏", "凝", "丹", "迎", "宛", "梦", "怜", "听", "巧", "静", "采", "凌", "芊", "琪"];
        private static var secondWoman1:Array = ["烟", "琴", "蓝", "梦", "丹", "柳", "萍", "寒", "霜", "白", "丝", "真", "露", "云", "芙", "容", "香", "荷", "风", "儿", "雪", "巧", "蕾", "芹", "灵", "卉", "夏", "岚", "蓉", "萱", "珍", "彤", "蕊", "曼", "兰", "晴", "珊", "青", "春", "玉", "瑶", "文", "双", "竹", "凝", "桃", "菡", "绿", "梅", "旋", "之", "蝶", "莲", "薇", "翠", "槐", "秋", "雁", "夜", "芊", "冬", "菲", "琪"];

        public function RandomName()
        {
			
        }

        public static function getName(sex:int) : String
        {
            var firstName:String = firstNames[random(0, (firstNames.length - 1))];
            var lastName:String = "";
            var flag:int = random(1, 10000000) % 8;
            if (sex == Man)
            {
                if (flag == 1)
                {
                    lastName = lastName + secondMan0[random(0, (secondMan0.length - 1))];
                }
                else if (flag == 2)
                {
                    lastName = lastName + secondMan1[random(0, (secondMan1.length - 1))];
                }
                else
                {
                    lastName = lastName + secondMan0[random(0, (secondMan0.length - 1))];
                    lastName = lastName + secondMan1[random(0, (secondMan1.length - 1))];
                }
            }
            else if (flag == 1)
            {
                lastName = lastName + secondWoman0[random(0, (secondWoman0.length - 1))];
            }
            else if (flag == 2)
            {
                lastName = lastName + secondWoman1[random(0, (secondWoman1.length - 1))];
            }
            else
            {
                lastName = lastName + secondWoman0[random(0, (secondWoman0.length - 1))];
                lastName = lastName + secondWoman1[random(0, (secondWoman1.length - 1))];
            }
            return firstName + lastName;
        }// end function

		/**  从 star 和 end中取出一个数字 
		*/
        public static function random(start:int, end:int) : int
        {
            var len:int = end - start;
            return Math.round(Math.random() * len) + start;
        }

    }
}
