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
	import com.msg.item.CharacterEquip;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class SOtherHeroInfo extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const DY_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.hero.SOtherHeroInfo.dy_id", "dyId", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		private var dy_id$field:int;

		private var hasField$0:uint = 0;

		public function clearDyId():void {
			hasField$0 &= 0xfffffffe;
			dy_id$field = new int();
		}

		public function get hasDyId():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set dyId(value:int):void {
			hasField$0 |= 0x1;
			dy_id$field = value;
		}

		public function get dyId():int {
			return dy_id$field;
		}

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

		private var power$field:int;

		public function clearPower():void {
			hasField$0 &= 0xfffffffd;
			power$field = new int();
		}

		public function get hasPower():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set power(value:int):void {
			hasField$0 |= 0x2;
			power$field = value;
		}

		public function get power():int {
			return power$field;
		}

		/**
		 *  @private
		 */
		public static const SEX:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.hero.SOtherHeroInfo.sex", "sex", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		private var sex$field:int;

		public function clearSex():void {
			hasField$0 &= 0xfffffffb;
			sex$field = new int();
		}

		public function get hasSex():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set sex(value:int):void {
			hasField$0 |= 0x4;
			sex$field = value;
		}

		public function get sex():int {
			return sex$field;
		}

		/**
		 *  @private
		 */
		public static const NAME:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.msg.hero.SOtherHeroInfo.name", "name", (5 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var name$field:String;

		public function clearName():void {
			name$field = null;
		}

		public function get hasName():Boolean {
			return name$field != null;
		}

		public function set name(value:String):void {
			name$field = value;
		}

		public function get name():String {
			return name$field;
		}

		/**
		 *  @private
		 */
		public static const EXP:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.hero.SOtherHeroInfo.exp", "exp", (6 << 3) | com.netease.protobuf.WireType.VARINT);

		private var exp$field:int;

		public function clearExp():void {
			hasField$0 &= 0xfffffff7;
			exp$field = new int();
		}

		public function get hasExp():Boolean {
			return (hasField$0 & 0x8) != 0;
		}

		public function set exp(value:int):void {
			hasField$0 |= 0x8;
			exp$field = value;
		}

		public function get exp():int {
			return exp$field;
		}

		/**
		 *  @private
		 */
		public static const CAREER:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.hero.SOtherHeroInfo.career", "career", (7 << 3) | com.netease.protobuf.WireType.VARINT);

		private var career$field:int;

		public function clearCareer():void {
			hasField$0 &= 0xffffffef;
			career$field = new int();
		}

		public function get hasCareer():Boolean {
			return (hasField$0 & 0x10) != 0;
		}

		public function set career(value:int):void {
			hasField$0 |= 0x10;
			career$field = value;
		}

		public function get career():int {
			return career$field;
		}

		/**
		 *  @private
		 */
		public static const LEVEL:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.hero.SOtherHeroInfo.level", "level", (8 << 3) | com.netease.protobuf.WireType.VARINT);

		private var level$field:int;

		public function clearLevel():void {
			hasField$0 &= 0xffffffdf;
			level$field = new int();
		}

		public function get hasLevel():Boolean {
			return (hasField$0 & 0x20) != 0;
		}

		public function set level(value:int):void {
			hasField$0 |= 0x20;
			level$field = value;
		}

		public function get level():int {
			return level$field;
		}

		/**
		 *  @private
		 */
		public static const SOCIATY:FieldDescriptor$TYPE_STRING = new FieldDescriptor$TYPE_STRING("com.msg.hero.SOtherHeroInfo.sociaty", "sociaty", (9 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED);

		private var sociaty$field:String;

		public function clearSociaty():void {
			sociaty$field = null;
		}

		public function get hasSociaty():Boolean {
			return sociaty$field != null;
		}

		public function set sociaty(value:String):void {
			sociaty$field = value;
		}

		public function get sociaty():String {
			return sociaty$field;
		}

		/**
		 *  @private
		 */
		public static const ENERGY:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.hero.SOtherHeroInfo.energy", "energy", (10 << 3) | com.netease.protobuf.WireType.VARINT);

		private var energy$field:int;

		public function clearEnergy():void {
			hasField$0 &= 0xffffffbf;
			energy$field = new int();
		}

		public function get hasEnergy():Boolean {
			return (hasField$0 & 0x40) != 0;
		}

		public function set energy(value:int):void {
			hasField$0 |= 0x40;
			energy$field = value;
		}

		public function get energy():int {
			return energy$field;
		}

		/**
		 *  @private
		 */
		public static const PK_VALUE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.hero.SOtherHeroInfo.pk_value", "pkValue", (11 << 3) | com.netease.protobuf.WireType.VARINT);

		private var pk_value$field:int;

		public function clearPkValue():void {
			hasField$0 &= 0xffffff7f;
			pk_value$field = new int();
		}

		public function get hasPkValue():Boolean {
			return (hasField$0 & 0x80) != 0;
		}

		public function set pkValue(value:int):void {
			hasField$0 |= 0x80;
			pk_value$field = value;
		}

		public function get pkValue():int {
			return pk_value$field;
		}

		/**
		 *  @private
		 */
		public static const SEE_VALUE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.hero.SOtherHeroInfo.see_value", "seeValue", (12 << 3) | com.netease.protobuf.WireType.VARINT);

		private var see_value$field:int;

		public function clearSeeValue():void {
			hasField$0 &= 0xfffffeff;
			see_value$field = new int();
		}

		public function get hasSeeValue():Boolean {
			return (hasField$0 & 0x100) != 0;
		}

		public function set seeValue(value:int):void {
			hasField$0 |= 0x100;
			see_value$field = value;
		}

		public function get seeValue():int {
			return see_value$field;
		}

		/**
		 *  @private
		 */
		public static const POTENTIAL:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.hero.SOtherHeroInfo.potential", "potential", (13 << 3) | com.netease.protobuf.WireType.VARINT);

		private var potential$field:int;

		public function clearPotential():void {
			hasField$0 &= 0xfffffdff;
			potential$field = new int();
		}

		public function get hasPotential():Boolean {
			return (hasField$0 & 0x200) != 0;
		}

		public function set potential(value:int):void {
			hasField$0 |= 0x200;
			potential$field = value;
		}

		public function get potential():int {
			return potential$field;
		}

		/**
		 *  @private
		 */
		public static const HONOUR:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.hero.SOtherHeroInfo.honour", "honour", (14 << 3) | com.netease.protobuf.WireType.VARINT);

		private var honour$field:int;

		public function clearHonour():void {
			hasField$0 &= 0xfffffbff;
			honour$field = new int();
		}

		public function get hasHonour():Boolean {
			return (hasField$0 & 0x400) != 0;
		}

		public function set honour(value:int):void {
			hasField$0 |= 0x400;
			honour$field = value;
		}

		public function get honour():int {
			return honour$field;
		}

		/**
		 *  @private
		 */
		public static const TITLE_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.hero.SOtherHeroInfo.title_id", "titleId", (15 << 3) | com.netease.protobuf.WireType.VARINT);

		private var title_id$field:int;

		public function clearTitleId():void {
			hasField$0 &= 0xfffff7ff;
			title_id$field = new int();
		}

		public function get hasTitleId():Boolean {
			return (hasField$0 & 0x800) != 0;
		}

		public function set titleId(value:int):void {
			hasField$0 |= 0x800;
			title_id$field = value;
		}

		public function get titleId():int {
			return title_id$field;
		}

		/**
		 *  @private
		 */
		public static const EQUIPS:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("com.msg.hero.SOtherHeroInfo.equips", "equips", (16 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.msg.item.CharacterEquip; });

		[ArrayElementType("com.msg.item.CharacterEquip")]
		public var equips:Array = [];

		/**
		 *  @private
		 */
		public static const CODE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.hero.SOtherHeroInfo.code", "code", (17 << 3) | com.netease.protobuf.WireType.VARINT);

		public var code:int;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			if (hasDyId) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, dy_id$field);
			}
			for (var attrArr$index:uint = 0; attrArr$index < this.attrArr.length; ++attrArr$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.attrArr[attrArr$index]);
			}
			if (hasPower) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, power$field);
			}
			if (hasSex) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, sex$field);
			}
			if (hasName) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 5);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, name$field);
			}
			if (hasExp) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 6);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, exp$field);
			}
			if (hasCareer) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 7);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, career$field);
			}
			if (hasLevel) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 8);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, level$field);
			}
			if (hasSociaty) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 9);
				com.netease.protobuf.WriteUtils.write$TYPE_STRING(output, sociaty$field);
			}
			if (hasEnergy) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 10);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, energy$field);
			}
			if (hasPkValue) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 11);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, pk_value$field);
			}
			if (hasSeeValue) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 12);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, see_value$field);
			}
			if (hasPotential) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 13);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, potential$field);
			}
			if (hasHonour) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 14);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, honour$field);
			}
			if (hasTitleId) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 15);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, title_id$field);
			}
			for (var equips$index:uint = 0; equips$index < this.equips.length; ++equips$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 16);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.equips[equips$index]);
			}
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 17);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.code);
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
			var title_id$count:uint = 0;
			var code$count:uint = 0;
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
					if (title_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SOtherHeroInfo.titleId cannot be set twice.');
					}
					++title_id$count;
					this.titleId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 16:
					this.equips.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new com.msg.item.CharacterEquip()));
					break;
				case 17:
					if (code$count != 0) {
						throw new flash.errors.IOError('Bad data format: SOtherHeroInfo.code cannot be set twice.');
					}
					++code$count;
					this.code = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
