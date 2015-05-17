package com.msg.hero {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.msg.common.AttrInfo;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class SOtherHeroInfo extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const DY_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.hero.SOtherHeroInfo.dy_id", "dyId", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var dyId:int;

		/**
		 *  @private
		 */
		public static const ATTR_ARR:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.msg.hero.SOtherHeroInfo.attr_arr", "attrArr", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.msg.common.AttrInfo; });

		[ArrayElementType("com.msg.common.AttrInfo")]
		public var attrArr:Array = [];

		/**
		 *  @private
		 */
		public static const POWER:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.hero.SOtherHeroInfo.power", "power", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		public var power:int;

		/**
		 *  @private
		 */
		public static const SEX:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.hero.SOtherHeroInfo.sex", "sex", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		public var sex:int;

		/**
		 *  @private
		 */
		public static const NAME:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.msg.hero.SOtherHeroInfo.name", "name", (5 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var name:String;

		/**
		 *  @private
		 */
		public static const EXP:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.hero.SOtherHeroInfo.exp", "exp", (6 << 3) | com.netease.protobuf.WireType.VARINT);

		public var exp:int;

		/**
		 *  @private
		 */
		public static const CAREER:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.hero.SOtherHeroInfo.career", "career", (7 << 3) | com.netease.protobuf.WireType.VARINT);

		public var career:int;

		/**
		 *  @private
		 */
		public static const LEVEL:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.hero.SOtherHeroInfo.level", "level", (8 << 3) | com.netease.protobuf.WireType.VARINT);

		public var level:int;

		/**
		 *  @private
		 */
		public static const SOCIATY:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.msg.hero.SOtherHeroInfo.sociaty", "sociaty", (9 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var sociaty:String;

		/**
		 *  @private
		 */
		public static const ENERGY:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.hero.SOtherHeroInfo.energy", "energy", (10 << 3) | com.netease.protobuf.WireType.VARINT);

		public var energy:int;

		/**
		 *  @private
		 */
		public static const PK_VALUE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.hero.SOtherHeroInfo.pk_value", "pkValue", (11 << 3) | com.netease.protobuf.WireType.VARINT);

		public var pkValue:int;

		/**
		 *  @private
		 */
		public static const SEE_VALUE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.hero.SOtherHeroInfo.see_value", "seeValue", (12 << 3) | com.netease.protobuf.WireType.VARINT);

		public var seeValue:int;

		/**
		 *  @private
		 */
		public static const POTENTIAL:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.hero.SOtherHeroInfo.potential", "potential", (13 << 3) | com.netease.protobuf.WireType.VARINT);

		public var potential:int;

		/**
		 *  @private
		 */
		public static const HONOUR:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.hero.SOtherHeroInfo.honour", "honour", (14 << 3) | com.netease.protobuf.WireType.VARINT);

		public var honour:int;

		/**
		 *  @private
		 */
		public static const TITLE:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.msg.hero.SOtherHeroInfo.title", "title", (15 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var title:String;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.dyId);
			for (var attrArr$index:uint = 0; attrArr$index < this.attrArr.length; ++attrArr$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.attrArr[attrArr$index]);
			}
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.power);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.sex);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 5);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.name);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 6);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.exp);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 7);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.career);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 8);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.level);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 9);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.sociaty);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 10);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.energy);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 11);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.pkValue);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 12);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.seeValue);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 13);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.potential);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 14);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.honour);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 15);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.title);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var dy_id$count:uint = 0;
			var power$count:uint = 0;
			var sex$count:uint = 0;
			var name$count:uint = 0;
			var exp$count:uint = 0;
			var career$count:uint = 0;
			var level$count:uint = 0;
			var sociaty$count:uint = 0;
			var energy$count:uint = 0;
			var pk_value$count:uint = 0;
			var see_value$count:uint = 0;
			var potential$count:uint = 0;
			var honour$count:uint = 0;
			var title$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (dy_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SOtherHeroInfo.dyId cannot be set twice.');
					}
					++dy_id$count;
					this.dyId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					this.attrArr.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.msg.common.AttrInfo()));
					break;
				case 3:
					if (power$count != 0) {
						throw new flash.errors.IOError('Bad data format: SOtherHeroInfo.power cannot be set twice.');
					}
					++power$count;
					this.power = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 4:
					if (sex$count != 0) {
						throw new flash.errors.IOError('Bad data format: SOtherHeroInfo.sex cannot be set twice.');
					}
					++sex$count;
					this.sex = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 5:
					if (name$count != 0) {
						throw new flash.errors.IOError('Bad data format: SOtherHeroInfo.name cannot be set twice.');
					}
					++name$count;
					this.name = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 6:
					if (exp$count != 0) {
						throw new flash.errors.IOError('Bad data format: SOtherHeroInfo.exp cannot be set twice.');
					}
					++exp$count;
					this.exp = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 7:
					if (career$count != 0) {
						throw new flash.errors.IOError('Bad data format: SOtherHeroInfo.career cannot be set twice.');
					}
					++career$count;
					this.career = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 8:
					if (level$count != 0) {
						throw new flash.errors.IOError('Bad data format: SOtherHeroInfo.level cannot be set twice.');
					}
					++level$count;
					this.level = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 9:
					if (sociaty$count != 0) {
						throw new flash.errors.IOError('Bad data format: SOtherHeroInfo.sociaty cannot be set twice.');
					}
					++sociaty$count;
					this.sociaty = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 10:
					if (energy$count != 0) {
						throw new flash.errors.IOError('Bad data format: SOtherHeroInfo.energy cannot be set twice.');
					}
					++energy$count;
					this.energy = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 11:
					if (pk_value$count != 0) {
						throw new flash.errors.IOError('Bad data format: SOtherHeroInfo.pkValue cannot be set twice.');
					}
					++pk_value$count;
					this.pkValue = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 12:
					if (see_value$count != 0) {
						throw new flash.errors.IOError('Bad data format: SOtherHeroInfo.seeValue cannot be set twice.');
					}
					++see_value$count;
					this.seeValue = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 13:
					if (potential$count != 0) {
						throw new flash.errors.IOError('Bad data format: SOtherHeroInfo.potential cannot be set twice.');
					}
					++potential$count;
					this.potential = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 14:
					if (honour$count != 0) {
						throw new flash.errors.IOError('Bad data format: SOtherHeroInfo.honour cannot be set twice.');
					}
					++honour$count;
					this.honour = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 15:
					if (title$count != 0) {
						throw new flash.errors.IOError('Bad data format: SOtherHeroInfo.title cannot be set twice.');
					}
					++title$count;
					this.title = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
