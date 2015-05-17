package com.msg.pets {
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
	public dynamic final class SPetUseItemNotify extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const DY_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.pets.SPetUseItemNotify.dy_id", "dyId", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var dyId:int;

		/**
		 *  @private
		 */
		public static const SKILL_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.pets.SPetUseItemNotify.skill_id", "skillId", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var skillId:int;

		/**
		 *  @private
		 */
		public static const ADD_HP:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.pets.SPetUseItemNotify.add_hp", "addHp", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		private var add_hp$field:int;

		private var hasField$0:uint = 0;

		public function clearAddHp():void {
			hasField$0 &= 0xfffffffe;
			add_hp$field = new int();
		}

		public function get hasAddHp():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set addHp(value:int):void {
			hasField$0 |= 0x1;
			add_hp$field = value;
		}

		public function get addHp():int {
			return add_hp$field;
		}

		/**
		 *  @private
		 */
		public static const HP:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.pets.SPetUseItemNotify.hp", "hp", (4 << 3) | com.netease.protobuf.WireType.VARINT);

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
		public static const ADD_MANA:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.pets.SPetUseItemNotify.add_mana", "addMana", (5 << 3) | com.netease.protobuf.WireType.VARINT);

		private var add_mana$field:int;

		public function clearAddMana():void {
			hasField$0 &= 0xfffffffb;
			add_mana$field = new int();
		}

		public function get hasAddMana():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set addMana(value:int):void {
			hasField$0 |= 0x4;
			add_mana$field = value;
		}

		public function get addMana():int {
			return add_mana$field;
		}

		/**
		 *  @private
		 */
		public static const MP:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.pets.SPetUseItemNotify.mp", "mp", (6 << 3) | com.netease.protobuf.WireType.VARINT);

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
		public static const BUFF_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.pets.SPetUseItemNotify.buff_id", "buffId", (7 << 3) | com.netease.protobuf.WireType.VARINT);

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
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.dyId);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.skillId);
			if (hasAddHp) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, add_hp$field);
			}
			if (hasHp) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, hp$field);
			}
			if (hasAddMana) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 5);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, add_mana$field);
			}
			if (hasMp) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 6);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, mp$field);
			}
			if (hasBuffId) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 7);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, buff_id$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var dy_id$count:uint = 0;
			var skill_id$count:uint = 0;
			var add_hp$count:uint = 0;
			var hp$count:uint = 0;
			var add_mana$count:uint = 0;
			var mp$count:uint = 0;
			var buff_id$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (dy_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SPetUseItemNotify.dyId cannot be set twice.');
					}
					++dy_id$count;
					this.dyId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (skill_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SPetUseItemNotify.skillId cannot be set twice.');
					}
					++skill_id$count;
					this.skillId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (add_hp$count != 0) {
						throw new flash.errors.IOError('Bad data format: SPetUseItemNotify.addHp cannot be set twice.');
					}
					++add_hp$count;
					this.addHp = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 4:
					if (hp$count != 0) {
						throw new flash.errors.IOError('Bad data format: SPetUseItemNotify.hp cannot be set twice.');
					}
					++hp$count;
					this.hp = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 5:
					if (add_mana$count != 0) {
						throw new flash.errors.IOError('Bad data format: SPetUseItemNotify.addMana cannot be set twice.');
					}
					++add_mana$count;
					this.addMana = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 6:
					if (mp$count != 0) {
						throw new flash.errors.IOError('Bad data format: SPetUseItemNotify.mp cannot be set twice.');
					}
					++mp$count;
					this.mp = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 7:
					if (buff_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: SPetUseItemNotify.buffId cannot be set twice.');
					}
					++buff_id$count;
					this.buffId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
