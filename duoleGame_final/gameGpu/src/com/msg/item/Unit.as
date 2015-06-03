package com.msg.item {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.msg.enumdef.ItemType;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class Unit extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const TYPE:FieldDescriptor$TYPE_ENUM = new FieldDescriptor$TYPE_ENUM("com.msg.item.Unit.type", "type", (1 << 3) | com.netease.protobuf.WireType.VARINT, com.msg.enumdef.ItemType);

		public var type:int;

		/**
		 *  @private
		 */
		public static const ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.Unit.id", "id", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var id:int;

		/**
		 *  @private
		 */
		public static const TEMPID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.Unit.tempid", "tempid", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		private var tempid$field:int;

		private var hasField$0:uint = 0;

		public function clearTempid():void {
			hasField$0 &= 0xfffffffe;
			tempid$field = new int();
		}

		public function get hasTempid():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set tempid(value:int):void {
			hasField$0 |= 0x1;
			tempid$field = value;
		}

		public function get tempid():int {
			return tempid$field;
		}

		/**
		 *  @private
		 */
		public static const SHOWID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.item.Unit.showid", "showid", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		private var showid$field:int;

		public function clearShowid():void {
			hasField$0 &= 0xfffffffd;
			showid$field = new int();
		}

		public function get hasShowid():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set showid(value:int):void {
			hasField$0 |= 0x2;
			showid$field = value;
		}

		public function get showid():int {
			return showid$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_ENUM(output, this.type);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.id);
			if (hasTempid) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, tempid$field);
			}
			if (hasShowid) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, showid$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var type$count:uint = 0;
			var id$count:uint = 0;
			var tempid$count:uint = 0;
			var showid$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (type$count != 0) {
						throw new flash.errors.IOError('Bad data format: Unit.type cannot be set twice.');
					}
					++type$count;
					this.type = com.netease.protobuf.ReadUtils.read$TYPE_ENUM(input);
					break;
				case 2:
					if (id$count != 0) {
						throw new flash.errors.IOError('Bad data format: Unit.id cannot be set twice.');
					}
					++id$count;
					this.id = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (tempid$count != 0) {
						throw new flash.errors.IOError('Bad data format: Unit.tempid cannot be set twice.');
					}
					++tempid$count;
					this.tempid = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 4:
					if (showid$count != 0) {
						throw new flash.errors.IOError('Bad data format: Unit.showid cannot be set twice.');
					}
					++showid$count;
					this.showid = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
