package com.msg.rank_pro {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.msg.rank_pro.PetSkill;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class PetInfo extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const QUALITY:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.rank_pro.PetInfo.quality", "quality", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var quality:int;

		/**
		 *  @private
		 */
		public static const PET_SKILL:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.msg.rank_pro.PetInfo.pet_skill", "petSkill", (2 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.msg.rank_pro.PetSkill; });

		[ArrayElementType("com.msg.rank_pro.PetSkill")]
		public var petSkill:Array = [];

		/**
		 *  @private
		 */
		public static const PET_CONFIG_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.rank_pro.PetInfo.pet_config_id", "petConfigId", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		private var pet_config_id$field:int;

		private var hasField$0:uint = 0;

		public function clearPetConfigId():void {
			hasField$0 &= 0xfffffffe;
			pet_config_id$field = new int();
		}

		public function get hasPetConfigId():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set petConfigId(value:int):void {
			hasField$0 |= 0x1;
			pet_config_id$field = value;
		}

		public function get petConfigId():int {
			return pet_config_id$field;
		}

		/**
		 *  @private
		 */
		public static const PET_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.rank_pro.PetInfo.pet_id", "petId", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		private var pet_id$field:int;

		public function clearPetId():void {
			hasField$0 &= 0xfffffffd;
			pet_id$field = new int();
		}

		public function get hasPetId():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set petId(value:int):void {
			hasField$0 |= 0x2;
			pet_id$field = value;
		}

		public function get petId():int {
			return pet_id$field;
		}

		/**
		 *  @private
		 */
		public static const BASIC_STRENGTH_APT:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.rank_pro.PetInfo.basic_strength_apt", "basicStrengthApt", (5 << 3) | com.netease.protobuf.WireType.VARINT);

		private var basic_strength_apt$field:int;

		public function clearBasicStrengthApt():void {
			hasField$0 &= 0xfffffffb;
			basic_strength_apt$field = new int();
		}

		public function get hasBasicStrengthApt():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set basicStrengthApt(value:int):void {
			hasField$0 |= 0x4;
			basic_strength_apt$field = value;
		}

		public function get basicStrengthApt():int {
			return basic_strength_apt$field;
		}

		/**
		 *  @private
		 */
		public static const BASIC_AGILE_APT:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.rank_pro.PetInfo.basic_agile_apt", "basicAgileApt", (6 << 3) | com.netease.protobuf.WireType.VARINT);

		private var basic_agile_apt$field:int;

		public function clearBasicAgileApt():void {
			hasField$0 &= 0xfffffff7;
			basic_agile_apt$field = new int();
		}

		public function get hasBasicAgileApt():Boolean {
			return (hasField$0 & 0x8) != 0;
		}

		public function set basicAgileApt(value:int):void {
			hasField$0 |= 0x8;
			basic_agile_apt$field = value;
		}

		public function get basicAgileApt():int {
			return basic_agile_apt$field;
		}

		/**
		 *  @private
		 */
		public static const BASIC_INTELLIGENCE_APT:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.rank_pro.PetInfo.basic_intelligence_apt", "basicIntelligenceApt", (7 << 3) | com.netease.protobuf.WireType.VARINT);

		private var basic_intelligence_apt$field:int;

		public function clearBasicIntelligenceApt():void {
			hasField$0 &= 0xffffffef;
			basic_intelligence_apt$field = new int();
		}

		public function get hasBasicIntelligenceApt():Boolean {
			return (hasField$0 & 0x10) != 0;
		}

		public function set basicIntelligenceApt(value:int):void {
			hasField$0 |= 0x10;
			basic_intelligence_apt$field = value;
		}

		public function get basicIntelligenceApt():int {
			return basic_intelligence_apt$field;
		}

		/**
		 *  @private
		 */
		public static const BASIC_PYHSIQUE_APT:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.rank_pro.PetInfo.basic_pyhsique_apt", "basicPyhsiqueApt", (8 << 3) | com.netease.protobuf.WireType.VARINT);

		private var basic_pyhsique_apt$field:int;

		public function clearBasicPyhsiqueApt():void {
			hasField$0 &= 0xffffffdf;
			basic_pyhsique_apt$field = new int();
		}

		public function get hasBasicPyhsiqueApt():Boolean {
			return (hasField$0 & 0x20) != 0;
		}

		public function set basicPyhsiqueApt(value:int):void {
			hasField$0 |= 0x20;
			basic_pyhsique_apt$field = value;
		}

		public function get basicPyhsiqueApt():int {
			return basic_pyhsique_apt$field;
		}

		/**
		 *  @private
		 */
		public static const BASIC_SPIRIT_APT:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.rank_pro.PetInfo.basic_spirit_apt", "basicSpiritApt", (9 << 3) | com.netease.protobuf.WireType.VARINT);

		private var basic_spirit_apt$field:int;

		public function clearBasicSpiritApt():void {
			hasField$0 &= 0xffffffbf;
			basic_spirit_apt$field = new int();
		}

		public function get hasBasicSpiritApt():Boolean {
			return (hasField$0 & 0x40) != 0;
		}

		public function set basicSpiritApt(value:int):void {
			hasField$0 |= 0x40;
			basic_spirit_apt$field = value;
		}

		public function get basicSpiritApt():int {
			return basic_spirit_apt$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.quality);
			for (var petSkill$index:uint = 0; petSkill$index < this.petSkill.length; ++petSkill$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.petSkill[petSkill$index]);
			}
			if (hasPetConfigId) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, pet_config_id$field);
			}
			if (hasPetId) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, pet_id$field);
			}
			if (hasBasicStrengthApt) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 5);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, basic_strength_apt$field);
			}
			if (hasBasicAgileApt) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 6);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, basic_agile_apt$field);
			}
			if (hasBasicIntelligenceApt) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 7);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, basic_intelligence_apt$field);
			}
			if (hasBasicPyhsiqueApt) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 8);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, basic_pyhsique_apt$field);
			}
			if (hasBasicSpiritApt) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 9);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, basic_spirit_apt$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var quality$count:uint = 0;
			var pet_config_id$count:uint = 0;
			var pet_id$count:uint = 0;
			var basic_strength_apt$count:uint = 0;
			var basic_agile_apt$count:uint = 0;
			var basic_intelligence_apt$count:uint = 0;
			var basic_pyhsique_apt$count:uint = 0;
			var basic_spirit_apt$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (quality$count != 0) {
						throw new flash.errors.IOError('Bad data format: PetInfo.quality cannot be set twice.');
					}
					++quality$count;
					this.quality = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					this.petSkill.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.msg.rank_pro.PetSkill()));
					break;
				case 3:
					if (pet_config_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: PetInfo.petConfigId cannot be set twice.');
					}
					++pet_config_id$count;
					this.petConfigId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 4:
					if (pet_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: PetInfo.petId cannot be set twice.');
					}
					++pet_id$count;
					this.petId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 5:
					if (basic_strength_apt$count != 0) {
						throw new flash.errors.IOError('Bad data format: PetInfo.basicStrengthApt cannot be set twice.');
					}
					++basic_strength_apt$count;
					this.basicStrengthApt = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 6:
					if (basic_agile_apt$count != 0) {
						throw new flash.errors.IOError('Bad data format: PetInfo.basicAgileApt cannot be set twice.');
					}
					++basic_agile_apt$count;
					this.basicAgileApt = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 7:
					if (basic_intelligence_apt$count != 0) {
						throw new flash.errors.IOError('Bad data format: PetInfo.basicIntelligenceApt cannot be set twice.');
					}
					++basic_intelligence_apt$count;
					this.basicIntelligenceApt = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 8:
					if (basic_pyhsique_apt$count != 0) {
						throw new flash.errors.IOError('Bad data format: PetInfo.basicPyhsiqueApt cannot be set twice.');
					}
					++basic_pyhsique_apt$count;
					this.basicPyhsiqueApt = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 9:
					if (basic_spirit_apt$count != 0) {
						throw new flash.errors.IOError('Bad data format: PetInfo.basicSpiritApt cannot be set twice.');
					}
					++basic_spirit_apt$count;
					this.basicSpiritApt = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
