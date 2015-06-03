package com.msg.divine_pulse_pro {
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
	public dynamic final class SDivinePulseInfoRsp extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const GOLD:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.divine_pulse_pro.SDivinePulseInfoRsp.gold", "gold", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var gold:int;

		/**
		 *  @private
		 */
		public static const WOOD:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.divine_pulse_pro.SDivinePulseInfoRsp.wood", "wood", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var wood:int;

		/**
		 *  @private
		 */
		public static const WATER:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.divine_pulse_pro.SDivinePulseInfoRsp.water", "water", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		public var water:int;

		/**
		 *  @private
		 */
		public static const FIRE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.divine_pulse_pro.SDivinePulseInfoRsp.fire", "fire", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		public var fire:int;

		/**
		 *  @private
		 */
		public static const EARTH:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.divine_pulse_pro.SDivinePulseInfoRsp.earth", "earth", (5 << 3) | com.netease.protobuf.WireType.VARINT);

		public var earth:int;

		/**
		 *  @private
		 */
		public static const LIGHT:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.divine_pulse_pro.SDivinePulseInfoRsp.light", "light", (6 << 3) | com.netease.protobuf.WireType.VARINT);

		public var light:int;

		/**
		 *  @private
		 */
		public static const DARK:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.divine_pulse_pro.SDivinePulseInfoRsp.dark", "dark", (7 << 3) | com.netease.protobuf.WireType.VARINT);

		public var dark:int;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.gold);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.wood);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.water);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.fire);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 5);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.earth);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 6);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.light);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 7);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.dark);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var gold$count:uint = 0;
			var wood$count:uint = 0;
			var water$count:uint = 0;
			var fire$count:uint = 0;
			var earth$count:uint = 0;
			var light$count:uint = 0;
			var dark$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (gold$count != 0) {
						throw new flash.errors.IOError('Bad data format: SDivinePulseInfoRsp.gold cannot be set twice.');
					}
					++gold$count;
					this.gold = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (wood$count != 0) {
						throw new flash.errors.IOError('Bad data format: SDivinePulseInfoRsp.wood cannot be set twice.');
					}
					++wood$count;
					this.wood = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (water$count != 0) {
						throw new flash.errors.IOError('Bad data format: SDivinePulseInfoRsp.water cannot be set twice.');
					}
					++water$count;
					this.water = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 4:
					if (fire$count != 0) {
						throw new flash.errors.IOError('Bad data format: SDivinePulseInfoRsp.fire cannot be set twice.');
					}
					++fire$count;
					this.fire = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 5:
					if (earth$count != 0) {
						throw new flash.errors.IOError('Bad data format: SDivinePulseInfoRsp.earth cannot be set twice.');
					}
					++earth$count;
					this.earth = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 6:
					if (light$count != 0) {
						throw new flash.errors.IOError('Bad data format: SDivinePulseInfoRsp.light cannot be set twice.');
					}
					++light$count;
					this.light = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 7:
					if (dark$count != 0) {
						throw new flash.errors.IOError('Bad data format: SDivinePulseInfoRsp.dark cannot be set twice.');
					}
					++dark$count;
					this.dark = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
