package com.msg.skill_pro {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class DamageInfo extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const TAG_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.skill_pro.DamageInfo.tag_id", "tagId", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var tagId:int;

		/**
		 *  @private
		 */
		public static const DAMAGE_TYPE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.skill_pro.DamageInfo.damage_type", "damageType", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var damageType:int;

		/**
		 *  @private
		 */
		public static const HP_CHANGE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.skill_pro.DamageInfo.hp_change", "hpChange", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		private var hp_change$field:int;

		private var hasField$0:uint = 0;

		public function clearHpChange():void {
			hasField$0 &= 0xfffffffe;
			hp_change$field = new int();
		}

		public function get hasHpChange():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set hpChange(value:int):void {
			hasField$0 |= 0x1;
			hp_change$field = value;
		}

		public function get hpChange():int {
			return hp_change$field;
		}

		/**
		 *  @private
		 */
		public static const HP:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.skill_pro.DamageInfo.hp", "hp", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		private var hp$field:int;

		public function clearHp():void {
			hasField$0 &= 0xfffffffd;
			hp$field = new int();
		}

		public function get hasHp():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set hp(value:int):void {
			hasField$0 |= 0x2;
			hp$field = value;
		}

		public function get hp():int {
			return hp$field;
		}

		/**
		 *  @private
		 */
		public static const MP_CHANGE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.skill_pro.DamageInfo.mp_change", "mpChange", (5 << 3) | com.netease.protobuf.WireType.VARINT);

		private var mp_change$field:int;

		public function clearMpChange():void {
			hasField$0 &= 0xfffffffb;
			mp_change$field = new int();
		}

		public function get hasMpChange():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set mpChange(value:int):void {
			hasField$0 |= 0x4;
			mp_change$field = value;
		}

		public function get mpChange():int {
			return mp_change$field;
		}

		/**
		 *  @private
		 */
		public static const MP:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.skill_pro.DamageInfo.mp", "mp", (6 << 3) | com.netease.protobuf.WireType.VARINT);

		private var mp$field:int;

		public function clearMp():void {
			hasField$0 &= 0xfffffff7;
			mp$field = new int();
		}

		public function get hasMp():Boolean {
			return (hasField$0 & 0x8) != 0;
		}

		public function set mp(value:int):void {
			hasField$0 |= 0x8;
			mp$field = value;
		}

		public function get mp():int {
			return mp$field;
		}

		/**
		 *  @private
		 */
		public static const BUFF_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.skill_pro.DamageInfo.buff_id", "buffId", (7 << 3) | com.netease.protobuf.WireType.VARINT);

		private var buff_id$field:int;

		public function clearBuffId():void {
			hasField$0 &= 0xffffffef;
			buff_id$field = new int();
		}

		public function get hasBuffId():Boolean {
			return (hasField$0 & 0x10) != 0;
		}

		public function set buffId(value:int):void {
			hasField$0 |= 0x10;
			buff_id$field = value;
		}

		public function get buffId():int {
			return buff_id$field;
		}

		/**
		 *  @private
		 */
		public static const BEAT_BACK_POS:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.skill_pro.DamageInfo.beat_back_pos", "beatBackPos", (8 << 3) | com.netease.protobuf.WireType.VARINT);

		private var beat_back_pos$field:int;

		public function clearBeatBackPos():void {
			hasField$0 &= 0xffffffdf;
			beat_back_pos$field = new int();
		}

		public function get hasBeatBackPos():Boolean {
			return (hasField$0 & 0x20) != 0;
		}

		public function set beatBackPos(value:int):void {
			hasField$0 |= 0x20;
			beat_back_pos$field = value;
		}

		public function get beatBackPos():int {
			return beat_back_pos$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.tagId);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.damageType);
			if (hasHpChange) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, hp_change$field);
			}
			if (hasHp) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, hp$field);
			}
			if (hasMpChange) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 5);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, mp_change$field);
			}
			if (hasMp) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 6);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, mp$field);
			}
			if (hasBuffId) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 7);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, buff_id$field);
			}
			if (hasBeatBackPos) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 8);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, beat_back_pos$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var tag_id$count:uint = 0;
			var damage_type$count:uint = 0;
			var hp_change$count:uint = 0;
			var hp$count:uint = 0;
			var mp_change$count:uint = 0;
			var mp$count:uint = 0;
			var buff_id$count:uint = 0;
			var beat_back_pos$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (tag_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: DamageInfo.tagId cannot be set twice.');
					}
					++tag_id$count;
					this.tagId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (damage_type$count != 0) {
						throw new flash.errors.IOError('Bad data format: DamageInfo.damageType cannot be set twice.');
					}
					++damage_type$count;
					this.damageType = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (hp_change$count != 0) {
						throw new flash.errors.IOError('Bad data format: DamageInfo.hpChange cannot be set twice.');
					}
					++hp_change$count;
					this.hpChange = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 4:
					if (hp$count != 0) {
						throw new flash.errors.IOError('Bad data format: DamageInfo.hp cannot be set twice.');
					}
					++hp$count;
					this.hp = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 5:
					if (mp_change$count != 0) {
						throw new flash.errors.IOError('Bad data format: DamageInfo.mpChange cannot be set twice.');
					}
					++mp_change$count;
					this.mpChange = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 6:
					if (mp$count != 0) {
						throw new flash.errors.IOError('Bad data format: DamageInfo.mp cannot be set twice.');
					}
					++mp$count;
					this.mp = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 7:
					if (buff_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: DamageInfo.buffId cannot be set twice.');
					}
					++buff_id$count;
					this.buffId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 8:
					if (beat_back_pos$count != 0) {
						throw new flash.errors.IOError('Bad data format: DamageInfo.beatBackPos cannot be set twice.');
					}
					++beat_back_pos$count;
					this.beatBackPos = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
