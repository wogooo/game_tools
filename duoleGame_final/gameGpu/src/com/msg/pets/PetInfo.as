package com.msg.pets {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.msg.pets.SPetAttr;
	import com.msg.common.SkillInfo;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class PetInfo extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const PET_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.pets.PetInfo.pet_id", "petId", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var petId:int;

		/**
		 *  @private
		 */
		public static const CONFIG_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.pets.PetInfo.config_id", "configId", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var configId:int;

		/**
		 *  @private
		 */
		public static const POTENTIAL:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.pets.PetInfo.potential", "potential", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		private var potential$field:int;

		private var hasField$0:uint = 0;

		public function clearPotential():void {
			hasField$0 &= 0xfffffffe;
			potential$field = new int();
		}

		public function get hasPotential():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set potential(value:int):void {
			hasField$0 |= 0x1;
			potential$field = value;
		}

		public function get potential():int {
			return potential$field;
		}

		/**
		 *  @private
		 */
		public static const EXP:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.pets.PetInfo.exp", "exp", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		public var exp:int;

		/**
		 *  @private
		 */
		public static const LV:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.pets.PetInfo.lv", "lv", (5 << 3) | com.netease.protobuf.WireType.VARINT);

		public var lv:int;

		/**
		 *  @private
		 */
		public static const HAPPY:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.pets.PetInfo.happy", "happy", (6 << 3) | com.netease.protobuf.WireType.VARINT);

		public var happy:int;

		/**
		 *  @private
		 */
		public static const SKILL_OPEN_SLOTS:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.pets.PetInfo.skill_open_slots", "skillOpenSlots", (7 << 3) | com.netease.protobuf.WireType.VARINT);

		public var skillOpenSlots:int;

		/**
		 *  @private
		 */
		public static const PET_NICKNAME:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.msg.pets.PetInfo.pet_nickname", "petNickname", (8 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		public var petNickname:String;

		/**
		 *  @private
		 */
		public static const PET_ATTR:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.msg.pets.PetInfo.pet_attr", "petAttr", (9 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.msg.pets.SPetAttr; });

		public var petAttr:com.msg.pets.SPetAttr;

		/**
		 *  @private
		 */
		public static const PET_SKILLS:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.msg.pets.PetInfo.pet_skills", "petSkills", (10 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.msg.common.SkillInfo; });

		[ArrayElementType("com.msg.common.SkillInfo")]
		public var petSkills:Array = [];

		/**
		 *  @private
		 */
		public static const ENHANCE_LV:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.pets.PetInfo.enhance_lv", "enhanceLv", (11 << 3) | com.netease.protobuf.WireType.VARINT);

		private var enhance_lv$field:int;

		public function clearEnhanceLv():void {
			hasField$0 &= 0xfffffffd;
			enhance_lv$field = new int();
		}

		public function get hasEnhanceLv():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set enhanceLv(value:int):void {
			hasField$0 |= 0x2;
			enhance_lv$field = value;
		}

		public function get enhanceLv():int {
			return enhance_lv$field;
		}

		/**
		 *  @private
		 */
		public static const DEFAULT_SKILL_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.pets.PetInfo.default_skill_id", "defaultSkillId", (12 << 3) | com.netease.protobuf.WireType.VARINT);

		public var defaultSkillId:int;

		/**
		 *  @private
		 */
		public static const QUALITY:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.pets.PetInfo.quality", "quality", (13 << 3) | com.netease.protobuf.WireType.VARINT);

		private var quality$field:int;

		public function clearQuality():void {
			hasField$0 &= 0xfffffffb;
			quality$field = new int();
		}

		public function get hasQuality():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set quality(value:int):void {
			hasField$0 |= 0x4;
			quality$field = value;
		}

		public function get quality():int {
			return quality$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.petId);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.configId);
			if (hasPotential) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, potential$field);
			}
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.exp);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 5);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.lv);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 6);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.happy);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 7);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.skillOpenSlots);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 8);
			com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, this.petNickname);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 9);
			com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.petAttr);
			for (var petSkills$index:uint = 0; petSkills$index < this.petSkills.length; ++petSkills$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 10);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.petSkills[petSkills$index]);
			}
			if (hasEnhanceLv) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 11);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, enhance_lv$field);
			}
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 12);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.defaultSkillId);
			if (hasQuality) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 13);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, quality$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var pet_id$count:uint = 0;
			var config_id$count:uint = 0;
			var potential$count:uint = 0;
			var exp$count:uint = 0;
			var lv$count:uint = 0;
			var happy$count:uint = 0;
			var skill_open_slots$count:uint = 0;
			var pet_nickname$count:uint = 0;
			var pet_attr$count:uint = 0;
			var enhance_lv$count:uint = 0;
			var default_skill_id$count:uint = 0;
			var quality$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (pet_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: PetInfo.petId cannot be set twice.');
					}
					++pet_id$count;
					this.petId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (config_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: PetInfo.configId cannot be set twice.');
					}
					++config_id$count;
					this.configId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (potential$count != 0) {
						throw new flash.errors.IOError('Bad data format: PetInfo.potential cannot be set twice.');
					}
					++potential$count;
					this.potential = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 4:
					if (exp$count != 0) {
						throw new flash.errors.IOError('Bad data format: PetInfo.exp cannot be set twice.');
					}
					++exp$count;
					this.exp = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 5:
					if (lv$count != 0) {
						throw new flash.errors.IOError('Bad data format: PetInfo.lv cannot be set twice.');
					}
					++lv$count;
					this.lv = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 6:
					if (happy$count != 0) {
						throw new flash.errors.IOError('Bad data format: PetInfo.happy cannot be set twice.');
					}
					++happy$count;
					this.happy = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 7:
					if (skill_open_slots$count != 0) {
						throw new flash.errors.IOError('Bad data format: PetInfo.skillOpenSlots cannot be set twice.');
					}
					++skill_open_slots$count;
					this.skillOpenSlots = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 8:
					if (pet_nickname$count != 0) {
						throw new flash.errors.IOError('Bad data format: PetInfo.petNickname cannot be set twice.');
					}
					++pet_nickname$count;
					this.petNickname = com.netease.protobuf.ReadUtils.read$TYPE_STRING(input);
					break;
				case 9:
					if (pet_attr$count != 0) {
						throw new flash.errors.IOError('Bad data format: PetInfo.petAttr cannot be set twice.');
					}
					++pet_attr$count;
					this.petAttr = new com.msg.pets.SPetAttr();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.petAttr);
					break;
				case 10:
					this.petSkills.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.msg.common.SkillInfo()));
					break;
				case 11:
					if (enhance_lv$count != 0) {
						throw new flash.errors.IOError('Bad data format: PetInfo.enhanceLv cannot be set twice.');
					}
					++enhance_lv$count;
					this.enhanceLv = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 12:
					if (default_skill_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: PetInfo.defaultSkillId cannot be set twice.');
					}
					++default_skill_id$count;
					this.defaultSkillId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 13:
					if (quality$count != 0) {
						throw new flash.errors.IOError('Bad data format: PetInfo.quality cannot be set twice.');
					}
					++quality$count;
					this.quality = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
