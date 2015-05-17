package com.msg.skill_pro {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.msg.skill_pro.DamageInfo;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class SFight extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const ATK_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.skill_pro.SFight.atk_id", "atkId", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var atkId:int;

		/**
		 *  @private
		 */
		public static const SKILL_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.skill_pro.SFight.skill_id", "skillId", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var skillId:int;

		/**
		 *  @private
		 */
		public static const SKILL_LEVEL:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.skill_pro.SFight.skill_level", "skillLevel", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		public var skillLevel:int;

		/**
		 *  @private
		 */
		public static const TAG_POS:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.skill_pro.SFight.tag_pos", "tagPos", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		private var tag_pos$field:int;

		private var hasField$0:uint = 0;

		public function clearTagPos():void {
			hasField$0 &= 0xfffffffe;
			tag_pos$field = new int();
		}

		public function get hasTagPos():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set tagPos(value:int):void {
			hasField$0 |= 0x1;
			tag_pos$field = value;
		}

		public function get tagPos():int {
			return tag_pos$field;
		}

		/**
		 *  @private
		 */
		public static const DAMAGE_INFO_ARR:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.msg.skill_pro.SFight.damage_info_arr", "damageInfoArr", (5 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.msg.skill_pro.DamageInfo; });

		[ArrayElementType("com.msg.skill_pro.DamageInfo")]
		public var damageInfoArr:Array = [];

		/**
		 *  @private
		 */
		public static const ATK_HP:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.skill_pro.SFight.atk_hp", "atkHp", (6 << 3) | com.netease.protobuf.WireType.VARINT);

		private var atk_hp$field:int;

		public function clearAtkHp():void {
			hasField$0 &= 0xfffffffd;
			atk_hp$field = new int();
		}

		public function get hasAtkHp():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set atkHp(value:int):void {
			hasField$0 |= 0x2;
			atk_hp$field = value;
		}

		public function get atkHp():int {
			return atk_hp$field;
		}

		/**
		 *  @private
		 */
		public static const ATK_MP:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.skill_pro.SFight.atk_mp", "atkMp", (7 << 3) | com.netease.protobuf.WireType.VARINT);

		private var atk_mp$field:int;

		public function clearAtkMp():void {
			hasField$0 &= 0xfffffffb;
			atk_mp$field = new int();
		}

		public function get hasAtkMp():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set atkMp(value:int):void {
			hasField$0 |= 0x4;
			atk_mp$field = value;
		}

		public function get atkMp():int {
			return atk_mp$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.atkId);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.skillId);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.skillLevel);
			if (hasTagPos) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, tag_pos$field);
			}
			for (var damageInfoArr$index:uint = 0; damageInfoArr$index < this.damageInfoArr.length; ++damageInfoArr$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 5);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.damageInfoArr[damageInfoArr$index]);
			}
			if (hasAtkHp) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 6);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, atk_hp$field);
			}
			if (hasAtkMp) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 7);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, atk_mp$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var atk_id$count:uint = 0;
			var skill_id$count:uint = 0;
			var skill_level$count:uint = 0;
			var tag_pos$count:uint = 0;
			var atk_hp$count:uint = 0;
			var atk_mp$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (atk_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SFight.atkId cannot be set twice.');
					}
					++atk_id$count;
					this.atkId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (skill_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SFight.skillId cannot be set twice.');
					}
					++skill_id$count;
					this.skillId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (skill_level$count != 0) {
						throw new flash.errors.IOError('Bad data format: SFight.skillLevel cannot be set twice.');
					}
					++skill_level$count;
					this.skillLevel = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 4:
					if (tag_pos$count != 0) {
						throw new flash.errors.IOError('Bad data format: SFight.tagPos cannot be set twice.');
					}
					++tag_pos$count;
					this.tagPos = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 5:
					this.damageInfoArr.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.msg.skill_pro.DamageInfo()));
					break;
				case 6:
					if (atk_hp$count != 0) {
						throw new flash.errors.IOError('Bad data format: SFight.atkHp cannot be set twice.');
					}
					++atk_hp$count;
					this.atkHp = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 7:
					if (atk_mp$count != 0) {
						throw new flash.errors.IOError('Bad data format: SFight.atkMp cannot be set twice.');
					}
					++atk_mp$count;
					this.atkMp = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
