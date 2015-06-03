package com.msg.item {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.msg.enumdef.BindingType;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class CharacterEquip extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const EQUIP_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.CharacterEquip.equip_id", "equipId", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var equipId:int;

		/**
		 *  @private
		 */
		public static const TEMPLATE_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.CharacterEquip.template_id", "templateId", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var templateId:int;

		/**
		 *  @private
		 */
		public static const BINDING_ATTR:FieldDescriptor$TYPE_ENUM = new FieldDescriptor$TYPE_ENUM("com.msg.item.CharacterEquip.binding_attr", "bindingAttr", (3 << 3) | com.netease.protobuf.WireType.VARINT, com.msg.enumdef.BindingType);

		public var bindingAttr:int;

		/**
		 *  @private
		 */
		public static const CUR_DURABILITY:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.CharacterEquip.cur_durability", "curDurability", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		public var curDurability:int;

		/**
		 *  @private
		 */
		public static const ENHANCE_LEVEL:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.CharacterEquip.enhance_level", "enhanceLevel", (5 << 3) | com.netease.protobuf.WireType.VARINT);

		public var enhanceLevel:int;

		/**
		 *  @private
		 */
		public static const GEM_1_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.CharacterEquip.gem_1_id", "gem_1Id", (6 << 3) | com.netease.protobuf.WireType.VARINT);

		private var gem_1_id$field:int;

		private var hasField$0:uint = 0;

		public function clearGem_1Id():void {
			hasField$0 &= 0xfffffffe;
			gem_1_id$field = new int();
		}

		public function get hasGem_1Id():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set gem_1Id(value:int):void {
			hasField$0 |= 0x1;
			gem_1_id$field = value;
		}

		public function get gem_1Id():int {
			return gem_1_id$field;
		}

		/**
		 *  @private
		 */
		public static const GEM_2_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.CharacterEquip.gem_2_id", "gem_2Id", (7 << 3) | com.netease.protobuf.WireType.VARINT);

		private var gem_2_id$field:int;

		public function clearGem_2Id():void {
			hasField$0 &= 0xfffffffd;
			gem_2_id$field = new int();
		}

		public function get hasGem_2Id():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set gem_2Id(value:int):void {
			hasField$0 |= 0x2;
			gem_2_id$field = value;
		}

		public function get gem_2Id():int {
			return gem_2_id$field;
		}

		/**
		 *  @private
		 */
		public static const GEM_3_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.CharacterEquip.gem_3_id", "gem_3Id", (8 << 3) | com.netease.protobuf.WireType.VARINT);

		private var gem_3_id$field:int;

		public function clearGem_3Id():void {
			hasField$0 &= 0xfffffffb;
			gem_3_id$field = new int();
		}

		public function get hasGem_3Id():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set gem_3Id(value:int):void {
			hasField$0 |= 0x4;
			gem_3_id$field = value;
		}

		public function get gem_3Id():int {
			return gem_3_id$field;
		}

		/**
		 *  @private
		 */
		public static const GEM_4_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.CharacterEquip.gem_4_id", "gem_4Id", (9 << 3) | com.netease.protobuf.WireType.VARINT);

		private var gem_4_id$field:int;

		public function clearGem_4Id():void {
			hasField$0 &= 0xfffffff7;
			gem_4_id$field = new int();
		}

		public function get hasGem_4Id():Boolean {
			return (hasField$0 & 0x8) != 0;
		}

		public function set gem_4Id(value:int):void {
			hasField$0 |= 0x8;
			gem_4_id$field = value;
		}

		public function get gem_4Id():int {
			return gem_4_id$field;
		}

		/**
		 *  @private
		 */
		public static const GEM_5_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.CharacterEquip.gem_5_id", "gem_5Id", (10 << 3) | com.netease.protobuf.WireType.VARINT);

		private var gem_5_id$field:int;

		public function clearGem_5Id():void {
			hasField$0 &= 0xffffffef;
			gem_5_id$field = new int();
		}

		public function get hasGem_5Id():Boolean {
			return (hasField$0 & 0x10) != 0;
		}

		public function set gem_5Id(value:int):void {
			hasField$0 |= 0x10;
			gem_5_id$field = value;
		}

		public function get gem_5Id():int {
			return gem_5_id$field;
		}

		/**
		 *  @private
		 */
		public static const GEM_6_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.CharacterEquip.gem_6_id", "gem_6Id", (11 << 3) | com.netease.protobuf.WireType.VARINT);

		private var gem_6_id$field:int;

		public function clearGem_6Id():void {
			hasField$0 &= 0xffffffdf;
			gem_6_id$field = new int();
		}

		public function get hasGem_6Id():Boolean {
			return (hasField$0 & 0x20) != 0;
		}

		public function set gem_6Id(value:int):void {
			hasField$0 |= 0x20;
			gem_6_id$field = value;
		}

		public function get gem_6Id():int {
			return gem_6_id$field;
		}

		/**
		 *  @private
		 */
		public static const GEM_7_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.CharacterEquip.gem_7_id", "gem_7Id", (12 << 3) | com.netease.protobuf.WireType.VARINT);

		private var gem_7_id$field:int;

		public function clearGem_7Id():void {
			hasField$0 &= 0xffffffbf;
			gem_7_id$field = new int();
		}

		public function get hasGem_7Id():Boolean {
			return (hasField$0 & 0x40) != 0;
		}

		public function set gem_7Id(value:int):void {
			hasField$0 |= 0x40;
			gem_7_id$field = value;
		}

		public function get gem_7Id():int {
			return gem_7_id$field;
		}

		/**
		 *  @private
		 */
		public static const GEM_8_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.CharacterEquip.gem_8_id", "gem_8Id", (13 << 3) | com.netease.protobuf.WireType.VARINT);

		private var gem_8_id$field:int;

		public function clearGem_8Id():void {
			hasField$0 &= 0xffffff7f;
			gem_8_id$field = new int();
		}

		public function get hasGem_8Id():Boolean {
			return (hasField$0 & 0x80) != 0;
		}

		public function set gem_8Id(value:int):void {
			hasField$0 |= 0x80;
			gem_8_id$field = value;
		}

		public function get gem_8Id():int {
			return gem_8_id$field;
		}

		/**
		 *  @private
		 */
		public static const OBTAIN_TIME:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.CharacterEquip.obtain_time", "obtainTime", (14 << 3) | com.netease.protobuf.WireType.VARINT);

		private var obtain_time$field:int;

		public function clearObtainTime():void {
			hasField$0 &= 0xfffffeff;
			obtain_time$field = new int();
		}

		public function get hasObtainTime():Boolean {
			return (hasField$0 & 0x100) != 0;
		}

		public function set obtainTime(value:int):void {
			hasField$0 |= 0x100;
			obtain_time$field = value;
		}

		public function get obtainTime():int {
			return obtain_time$field;
		}

		/**
		 *  @private
		 */
		public static const APP_ATTR_T1:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.CharacterEquip.app_attr_t1", "appAttrT1", (15 << 3) | com.netease.protobuf.WireType.VARINT);

		private var app_attr_t1$field:int;

		public function clearAppAttrT1():void {
			hasField$0 &= 0xfffffdff;
			app_attr_t1$field = new int();
		}

		public function get hasAppAttrT1():Boolean {
			return (hasField$0 & 0x200) != 0;
		}

		public function set appAttrT1(value:int):void {
			hasField$0 |= 0x200;
			app_attr_t1$field = value;
		}

		public function get appAttrT1():int {
			return app_attr_t1$field;
		}

		/**
		 *  @private
		 */
		public static const APP_ATTR_V1:FieldDescriptor$TYPE_DOUBLE = new FieldDescriptor$TYPE_DOUBLE("com.msg.item.CharacterEquip.app_attr_v1", "appAttrV1", (16 << 3) | com.netease.protobuf.WireType.FIXED_64_BIT);

		private var app_attr_v1$field:Number;

		public function clearAppAttrV1():void {
			hasField$0 &= 0xfffffbff;
			app_attr_v1$field = new Number();
		}

		public function get hasAppAttrV1():Boolean {
			return (hasField$0 & 0x400) != 0;
		}

		public function set appAttrV1(value:Number):void {
			hasField$0 |= 0x400;
			app_attr_v1$field = value;
		}

		public function get appAttrV1():Number {
			return app_attr_v1$field;
		}

		/**
		 *  @private
		 */
		public static const APP_ATTR_C1:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.msg.item.CharacterEquip.app_attr_c1", "appAttrC1", (17 << 3) | com.netease.protobuf.WireType.VARINT);

		private var app_attr_c1$field:uint;

		public function clearAppAttrC1():void {
			hasField$0 &= 0xfffff7ff;
			app_attr_c1$field = new uint();
		}

		public function get hasAppAttrC1():Boolean {
			return (hasField$0 & 0x800) != 0;
		}

		public function set appAttrC1(value:uint):void {
			hasField$0 |= 0x800;
			app_attr_c1$field = value;
		}

		public function get appAttrC1():uint {
			return app_attr_c1$field;
		}

		/**
		 *  @private
		 */
		public static const APP_ATTR_L1:FieldDescriptor$TYPE_BOOL = new FieldDescriptor$TYPE_BOOL("com.msg.item.CharacterEquip.app_attr_l1", "appAttrL1", (18 << 3) | com.netease.protobuf.WireType.VARINT);

		private var app_attr_l1$field:Boolean;

		public function clearAppAttrL1():void {
			hasField$0 &= 0xffffefff;
			app_attr_l1$field = new Boolean();
		}

		public function get hasAppAttrL1():Boolean {
			return (hasField$0 & 0x1000) != 0;
		}

		public function set appAttrL1(value:Boolean):void {
			hasField$0 |= 0x1000;
			app_attr_l1$field = value;
		}

		public function get appAttrL1():Boolean {
			return app_attr_l1$field;
		}

		/**
		 *  @private
		 */
		public static const APP_ATTR_T2:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.CharacterEquip.app_attr_t2", "appAttrT2", (19 << 3) | com.netease.protobuf.WireType.VARINT);

		private var app_attr_t2$field:int;

		public function clearAppAttrT2():void {
			hasField$0 &= 0xffffdfff;
			app_attr_t2$field = new int();
		}

		public function get hasAppAttrT2():Boolean {
			return (hasField$0 & 0x2000) != 0;
		}

		public function set appAttrT2(value:int):void {
			hasField$0 |= 0x2000;
			app_attr_t2$field = value;
		}

		public function get appAttrT2():int {
			return app_attr_t2$field;
		}

		/**
		 *  @private
		 */
		public static const APP_ATTR_V2:FieldDescriptor$TYPE_DOUBLE = new FieldDescriptor$TYPE_DOUBLE("com.msg.item.CharacterEquip.app_attr_v2", "appAttrV2", (20 << 3) | com.netease.protobuf.WireType.FIXED_64_BIT);

		private var app_attr_v2$field:Number;

		public function clearAppAttrV2():void {
			hasField$0 &= 0xffffbfff;
			app_attr_v2$field = new Number();
		}

		public function get hasAppAttrV2():Boolean {
			return (hasField$0 & 0x4000) != 0;
		}

		public function set appAttrV2(value:Number):void {
			hasField$0 |= 0x4000;
			app_attr_v2$field = value;
		}

		public function get appAttrV2():Number {
			return app_attr_v2$field;
		}

		/**
		 *  @private
		 */
		public static const APP_ATTR_C2:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.msg.item.CharacterEquip.app_attr_c2", "appAttrC2", (21 << 3) | com.netease.protobuf.WireType.VARINT);

		private var app_attr_c2$field:uint;

		public function clearAppAttrC2():void {
			hasField$0 &= 0xffff7fff;
			app_attr_c2$field = new uint();
		}

		public function get hasAppAttrC2():Boolean {
			return (hasField$0 & 0x8000) != 0;
		}

		public function set appAttrC2(value:uint):void {
			hasField$0 |= 0x8000;
			app_attr_c2$field = value;
		}

		public function get appAttrC2():uint {
			return app_attr_c2$field;
		}

		/**
		 *  @private
		 */
		public static const APP_ATTR_L2:FieldDescriptor$TYPE_BOOL = new FieldDescriptor$TYPE_BOOL("com.msg.item.CharacterEquip.app_attr_l2", "appAttrL2", (22 << 3) | com.netease.protobuf.WireType.VARINT);

		private var app_attr_l2$field:Boolean;

		public function clearAppAttrL2():void {
			hasField$0 &= 0xfffeffff;
			app_attr_l2$field = new Boolean();
		}

		public function get hasAppAttrL2():Boolean {
			return (hasField$0 & 0x10000) != 0;
		}

		public function set appAttrL2(value:Boolean):void {
			hasField$0 |= 0x10000;
			app_attr_l2$field = value;
		}

		public function get appAttrL2():Boolean {
			return app_attr_l2$field;
		}

		/**
		 *  @private
		 */
		public static const APP_ATTR_T3:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.CharacterEquip.app_attr_t3", "appAttrT3", (23 << 3) | com.netease.protobuf.WireType.VARINT);

		private var app_attr_t3$field:int;

		public function clearAppAttrT3():void {
			hasField$0 &= 0xfffdffff;
			app_attr_t3$field = new int();
		}

		public function get hasAppAttrT3():Boolean {
			return (hasField$0 & 0x20000) != 0;
		}

		public function set appAttrT3(value:int):void {
			hasField$0 |= 0x20000;
			app_attr_t3$field = value;
		}

		public function get appAttrT3():int {
			return app_attr_t3$field;
		}

		/**
		 *  @private
		 */
		public static const APP_ATTR_V3:FieldDescriptor$TYPE_DOUBLE = new FieldDescriptor$TYPE_DOUBLE("com.msg.item.CharacterEquip.app_attr_v3", "appAttrV3", (24 << 3) | com.netease.protobuf.WireType.FIXED_64_BIT);

		private var app_attr_v3$field:Number;

		public function clearAppAttrV3():void {
			hasField$0 &= 0xfffbffff;
			app_attr_v3$field = new Number();
		}

		public function get hasAppAttrV3():Boolean {
			return (hasField$0 & 0x40000) != 0;
		}

		public function set appAttrV3(value:Number):void {
			hasField$0 |= 0x40000;
			app_attr_v3$field = value;
		}

		public function get appAttrV3():Number {
			return app_attr_v3$field;
		}

		/**
		 *  @private
		 */
		public static const APP_ATTR_C3:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.msg.item.CharacterEquip.app_attr_c3", "appAttrC3", (25 << 3) | com.netease.protobuf.WireType.VARINT);

		private var app_attr_c3$field:uint;

		public function clearAppAttrC3():void {
			hasField$0 &= 0xfff7ffff;
			app_attr_c3$field = new uint();
		}

		public function get hasAppAttrC3():Boolean {
			return (hasField$0 & 0x80000) != 0;
		}

		public function set appAttrC3(value:uint):void {
			hasField$0 |= 0x80000;
			app_attr_c3$field = value;
		}

		public function get appAttrC3():uint {
			return app_attr_c3$field;
		}

		/**
		 *  @private
		 */
		public static const APP_ATTR_L3:FieldDescriptor$TYPE_BOOL = new FieldDescriptor$TYPE_BOOL("com.msg.item.CharacterEquip.app_attr_l3", "appAttrL3", (26 << 3) | com.netease.protobuf.WireType.VARINT);

		private var app_attr_l3$field:Boolean;

		public function clearAppAttrL3():void {
			hasField$0 &= 0xffefffff;
			app_attr_l3$field = new Boolean();
		}

		public function get hasAppAttrL3():Boolean {
			return (hasField$0 & 0x100000) != 0;
		}

		public function set appAttrL3(value:Boolean):void {
			hasField$0 |= 0x100000;
			app_attr_l3$field = value;
		}

		public function get appAttrL3():Boolean {
			return app_attr_l3$field;
		}

		/**
		 *  @private
		 */
		public static const APP_ATTR_T4:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.CharacterEquip.app_attr_t4", "appAttrT4", (27 << 3) | com.netease.protobuf.WireType.VARINT);

		private var app_attr_t4$field:int;

		public function clearAppAttrT4():void {
			hasField$0 &= 0xffdfffff;
			app_attr_t4$field = new int();
		}

		public function get hasAppAttrT4():Boolean {
			return (hasField$0 & 0x200000) != 0;
		}

		public function set appAttrT4(value:int):void {
			hasField$0 |= 0x200000;
			app_attr_t4$field = value;
		}

		public function get appAttrT4():int {
			return app_attr_t4$field;
		}

		/**
		 *  @private
		 */
		public static const APP_ATTR_V4:FieldDescriptor$TYPE_DOUBLE = new FieldDescriptor$TYPE_DOUBLE("com.msg.item.CharacterEquip.app_attr_v4", "appAttrV4", (28 << 3) | com.netease.protobuf.WireType.FIXED_64_BIT);

		private var app_attr_v4$field:Number;

		public function clearAppAttrV4():void {
			hasField$0 &= 0xffbfffff;
			app_attr_v4$field = new Number();
		}

		public function get hasAppAttrV4():Boolean {
			return (hasField$0 & 0x400000) != 0;
		}

		public function set appAttrV4(value:Number):void {
			hasField$0 |= 0x400000;
			app_attr_v4$field = value;
		}

		public function get appAttrV4():Number {
			return app_attr_v4$field;
		}

		/**
		 *  @private
		 */
		public static const APP_ATTR_C4:FieldDescriptor$TYPE_UINT32 = new FieldDescriptor$TYPE_UINT32("com.msg.item.CharacterEquip.app_attr_c4", "appAttrC4", (29 << 3) | com.netease.protobuf.WireType.VARINT);

		private var app_attr_c4$field:uint;

		public function clearAppAttrC4():void {
			hasField$0 &= 0xff7fffff;
			app_attr_c4$field = new uint();
		}

		public function get hasAppAttrC4():Boolean {
			return (hasField$0 & 0x800000) != 0;
		}

		public function set appAttrC4(value:uint):void {
			hasField$0 |= 0x800000;
			app_attr_c4$field = value;
		}

		public function get appAttrC4():uint {
			return app_attr_c4$field;
		}

		/**
		 *  @private
		 */
		public static const APP_ATTR_L4:FieldDescriptor$TYPE_BOOL = new FieldDescriptor$TYPE_BOOL("com.msg.item.CharacterEquip.app_attr_l4", "appAttrL4", (30 << 3) | com.netease.protobuf.WireType.VARINT);

		private var app_attr_l4$field:Boolean;

		public function clearAppAttrL4():void {
			hasField$0 &= 0xfeffffff;
			app_attr_l4$field = new Boolean();
		}

		public function get hasAppAttrL4():Boolean {
			return (hasField$0 & 0x1000000) != 0;
		}

		public function set appAttrL4(value:Boolean):void {
			hasField$0 |= 0x1000000;
			app_attr_l4$field = value;
		}

		public function get appAttrL4():Boolean {
			return app_attr_l4$field;
		}

		/**
		 *  @private
		 */
		public static const DEFT_LOCK_NUM:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.CharacterEquip.deft_lock_num", "deftLockNum", (31 << 3) | com.netease.protobuf.WireType.VARINT);

		private var deft_lock_num$field:int;

		public function clearDeftLockNum():void {
			hasField$0 &= 0xfdffffff;
			deft_lock_num$field = new int();
		}

		public function get hasDeftLockNum():Boolean {
			return (hasField$0 & 0x2000000) != 0;
		}

		public function set deftLockNum(value:int):void {
			hasField$0 |= 0x2000000;
			deft_lock_num$field = value;
		}

		public function get deftLockNum():int {
			return deft_lock_num$field;
		}

		/**
		 *  @private
		 */
		public static const STAR:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.CharacterEquip.star", "star", (32 << 3) | com.netease.protobuf.WireType.VARINT);

		private var star$field:int;

		public function clearStar():void {
			hasField$0 &= 0xfbffffff;
			star$field = new int();
		}

		public function get hasStar():Boolean {
			return (hasField$0 & 0x4000000) != 0;
		}

		public function set star(value:int):void {
			hasField$0 |= 0x4000000;
			star$field = value;
		}

		public function get star():int {
			return star$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.equipId);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.templateId);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_ENUM(output, this.bindingAttr);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.curDurability);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 5);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.enhanceLevel);
			if (hasGem_1Id) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 6);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, gem_1_id$field);
			}
			if (hasGem_2Id) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 7);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, gem_2_id$field);
			}
			if (hasGem_3Id) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 8);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, gem_3_id$field);
			}
			if (hasGem_4Id) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 9);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, gem_4_id$field);
			}
			if (hasGem_5Id) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 10);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, gem_5_id$field);
			}
			if (hasGem_6Id) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 11);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, gem_6_id$field);
			}
			if (hasGem_7Id) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 12);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, gem_7_id$field);
			}
			if (hasGem_8Id) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 13);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, gem_8_id$field);
			}
			if (hasObtainTime) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 14);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, obtain_time$field);
			}
			if (hasAppAttrT1) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 15);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, app_attr_t1$field);
			}
			if (hasAppAttrV1) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.FIXED_64_BIT, 16);
				com.netease.protobuf.WriteUtils.write$TYPE_DOUBLE(output, app_attr_v1$field);
			}
			if (hasAppAttrC1) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 17);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, app_attr_c1$field);
			}
			if (hasAppAttrL1) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 18);
				com.netease.protobuf.WriteUtils.write$TYPE_BOOL(output, app_attr_l1$field);
			}
			if (hasAppAttrT2) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 19);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, app_attr_t2$field);
			}
			if (hasAppAttrV2) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.FIXED_64_BIT, 20);
				com.netease.protobuf.WriteUtils.write$TYPE_DOUBLE(output, app_attr_v2$field);
			}
			if (hasAppAttrC2) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 21);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, app_attr_c2$field);
			}
			if (hasAppAttrL2) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 22);
				com.netease.protobuf.WriteUtils.write$TYPE_BOOL(output, app_attr_l2$field);
			}
			if (hasAppAttrT3) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 23);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, app_attr_t3$field);
			}
			if (hasAppAttrV3) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.FIXED_64_BIT, 24);
				com.netease.protobuf.WriteUtils.write$TYPE_DOUBLE(output, app_attr_v3$field);
			}
			if (hasAppAttrC3) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 25);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, app_attr_c3$field);
			}
			if (hasAppAttrL3) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 26);
				com.netease.protobuf.WriteUtils.write$TYPE_BOOL(output, app_attr_l3$field);
			}
			if (hasAppAttrT4) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 27);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, app_attr_t4$field);
			}
			if (hasAppAttrV4) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.FIXED_64_BIT, 28);
				com.netease.protobuf.WriteUtils.write$TYPE_DOUBLE(output, app_attr_v4$field);
			}
			if (hasAppAttrC4) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 29);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, app_attr_c4$field);
			}
			if (hasAppAttrL4) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 30);
				com.netease.protobuf.WriteUtils.write$TYPE_BOOL(output, app_attr_l4$field);
			}
			if (hasDeftLockNum) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 31);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, deft_lock_num$field);
			}
			if (hasStar) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 32);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, star$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var equip_id$count:uint = 0;
			var template_id$count:uint = 0;
			var binding_attr$count:uint = 0;
			var cur_durability$count:uint = 0;
			var enhance_level$count:uint = 0;
			var gem_1_id$count:uint = 0;
			var gem_2_id$count:uint = 0;
			var gem_3_id$count:uint = 0;
			var gem_4_id$count:uint = 0;
			var gem_5_id$count:uint = 0;
			var gem_6_id$count:uint = 0;
			var gem_7_id$count:uint = 0;
			var gem_8_id$count:uint = 0;
			var obtain_time$count:uint = 0;
			var app_attr_t1$count:uint = 0;
			var app_attr_v1$count:uint = 0;
			var app_attr_c1$count:uint = 0;
			var app_attr_l1$count:uint = 0;
			var app_attr_t2$count:uint = 0;
			var app_attr_v2$count:uint = 0;
			var app_attr_c2$count:uint = 0;
			var app_attr_l2$count:uint = 0;
			var app_attr_t3$count:uint = 0;
			var app_attr_v3$count:uint = 0;
			var app_attr_c3$count:uint = 0;
			var app_attr_l3$count:uint = 0;
			var app_attr_t4$count:uint = 0;
			var app_attr_v4$count:uint = 0;
			var app_attr_c4$count:uint = 0;
			var app_attr_l4$count:uint = 0;
			var deft_lock_num$count:uint = 0;
			var star$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (equip_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: CharacterEquip.equipId cannot be set twice.');
					}
					++equip_id$count;
					this.equipId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (template_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: CharacterEquip.templateId cannot be set twice.');
					}
					++template_id$count;
					this.templateId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (binding_attr$count != 0) {
						throw new flash.errors.IOError('Bad data format: CharacterEquip.bindingAttr cannot be set twice.');
					}
					++binding_attr$count;
					this.bindingAttr = com.netease.protobuf.ReadUtils.read$TYPE_ENUM(input);
					break;
				case 4:
					if (cur_durability$count != 0) {
						throw new flash.errors.IOError('Bad data format: CharacterEquip.curDurability cannot be set twice.');
					}
					++cur_durability$count;
					this.curDurability = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 5:
					if (enhance_level$count != 0) {
						throw new flash.errors.IOError('Bad data format: CharacterEquip.enhanceLevel cannot be set twice.');
					}
					++enhance_level$count;
					this.enhanceLevel = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 6:
					if (gem_1_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: CharacterEquip.gem_1Id cannot be set twice.');
					}
					++gem_1_id$count;
					this.gem_1Id = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 7:
					if (gem_2_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: CharacterEquip.gem_2Id cannot be set twice.');
					}
					++gem_2_id$count;
					this.gem_2Id = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 8:
					if (gem_3_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: CharacterEquip.gem_3Id cannot be set twice.');
					}
					++gem_3_id$count;
					this.gem_3Id = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 9:
					if (gem_4_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: CharacterEquip.gem_4Id cannot be set twice.');
					}
					++gem_4_id$count;
					this.gem_4Id = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 10:
					if (gem_5_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: CharacterEquip.gem_5Id cannot be set twice.');
					}
					++gem_5_id$count;
					this.gem_5Id = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 11:
					if (gem_6_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: CharacterEquip.gem_6Id cannot be set twice.');
					}
					++gem_6_id$count;
					this.gem_6Id = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 12:
					if (gem_7_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: CharacterEquip.gem_7Id cannot be set twice.');
					}
					++gem_7_id$count;
					this.gem_7Id = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 13:
					if (gem_8_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: CharacterEquip.gem_8Id cannot be set twice.');
					}
					++gem_8_id$count;
					this.gem_8Id = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 14:
					if (obtain_time$count != 0) {
						throw new flash.errors.IOError('Bad data format: CharacterEquip.obtainTime cannot be set twice.');
					}
					++obtain_time$count;
					this.obtainTime = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 15:
					if (app_attr_t1$count != 0) {
						throw new flash.errors.IOError('Bad data format: CharacterEquip.appAttrT1 cannot be set twice.');
					}
					++app_attr_t1$count;
					this.appAttrT1 = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 16:
					if (app_attr_v1$count != 0) {
						throw new flash.errors.IOError('Bad data format: CharacterEquip.appAttrV1 cannot be set twice.');
					}
					++app_attr_v1$count;
					this.appAttrV1 = com.netease.protobuf.ReadUtils.read$TYPE_DOUBLE(input);
					break;
				case 17:
					if (app_attr_c1$count != 0) {
						throw new flash.errors.IOError('Bad data format: CharacterEquip.appAttrC1 cannot be set twice.');
					}
					++app_attr_c1$count;
					this.appAttrC1 = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 18:
					if (app_attr_l1$count != 0) {
						throw new flash.errors.IOError('Bad data format: CharacterEquip.appAttrL1 cannot be set twice.');
					}
					++app_attr_l1$count;
					this.appAttrL1 = com.netease.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				case 19:
					if (app_attr_t2$count != 0) {
						throw new flash.errors.IOError('Bad data format: CharacterEquip.appAttrT2 cannot be set twice.');
					}
					++app_attr_t2$count;
					this.appAttrT2 = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 20:
					if (app_attr_v2$count != 0) {
						throw new flash.errors.IOError('Bad data format: CharacterEquip.appAttrV2 cannot be set twice.');
					}
					++app_attr_v2$count;
					this.appAttrV2 = com.netease.protobuf.ReadUtils.read$TYPE_DOUBLE(input);
					break;
				case 21:
					if (app_attr_c2$count != 0) {
						throw new flash.errors.IOError('Bad data format: CharacterEquip.appAttrC2 cannot be set twice.');
					}
					++app_attr_c2$count;
					this.appAttrC2 = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 22:
					if (app_attr_l2$count != 0) {
						throw new flash.errors.IOError('Bad data format: CharacterEquip.appAttrL2 cannot be set twice.');
					}
					++app_attr_l2$count;
					this.appAttrL2 = com.netease.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				case 23:
					if (app_attr_t3$count != 0) {
						throw new flash.errors.IOError('Bad data format: CharacterEquip.appAttrT3 cannot be set twice.');
					}
					++app_attr_t3$count;
					this.appAttrT3 = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 24:
					if (app_attr_v3$count != 0) {
						throw new flash.errors.IOError('Bad data format: CharacterEquip.appAttrV3 cannot be set twice.');
					}
					++app_attr_v3$count;
					this.appAttrV3 = com.netease.protobuf.ReadUtils.read$TYPE_DOUBLE(input);
					break;
				case 25:
					if (app_attr_c3$count != 0) {
						throw new flash.errors.IOError('Bad data format: CharacterEquip.appAttrC3 cannot be set twice.');
					}
					++app_attr_c3$count;
					this.appAttrC3 = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 26:
					if (app_attr_l3$count != 0) {
						throw new flash.errors.IOError('Bad data format: CharacterEquip.appAttrL3 cannot be set twice.');
					}
					++app_attr_l3$count;
					this.appAttrL3 = com.netease.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				case 27:
					if (app_attr_t4$count != 0) {
						throw new flash.errors.IOError('Bad data format: CharacterEquip.appAttrT4 cannot be set twice.');
					}
					++app_attr_t4$count;
					this.appAttrT4 = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 28:
					if (app_attr_v4$count != 0) {
						throw new flash.errors.IOError('Bad data format: CharacterEquip.appAttrV4 cannot be set twice.');
					}
					++app_attr_v4$count;
					this.appAttrV4 = com.netease.protobuf.ReadUtils.read$TYPE_DOUBLE(input);
					break;
				case 29:
					if (app_attr_c4$count != 0) {
						throw new flash.errors.IOError('Bad data format: CharacterEquip.appAttrC4 cannot be set twice.');
					}
					++app_attr_c4$count;
					this.appAttrC4 = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
					break;
				case 30:
					if (app_attr_l4$count != 0) {
						throw new flash.errors.IOError('Bad data format: CharacterEquip.appAttrL4 cannot be set twice.');
					}
					++app_attr_l4$count;
					this.appAttrL4 = com.netease.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				case 31:
					if (deft_lock_num$count != 0) {
						throw new flash.errors.IOError('Bad data format: CharacterEquip.deftLockNum cannot be set twice.');
					}
					++deft_lock_num$count;
					this.deftLockNum = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 32:
					if (star$count != 0) {
						throw new flash.errors.IOError('Bad data format: CharacterEquip.star cannot be set twice.');
					}
					++star$count;
					this.star = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
