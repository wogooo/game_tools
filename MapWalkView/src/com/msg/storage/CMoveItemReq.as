package com.msg.storage {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import com.msg.enumdef.MovDirect;
	import com.msg.item.Unit;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class CMoveItemReq extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const MOV_DIRECT:FieldDescriptor$TYPE_ENUM = new FieldDescriptor$TYPE_ENUM("com.msg.storage.CMoveItemReq.mov_direct", "movDirect", (1 << 3) | com.netease.protobuf.WireType.VARINT, com.msg.enumdef.MovDirect);

		public var movDirect:int;

		/**
		 *  @private
		 */
		public static const SOURCE_POS:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.storage.CMoveItemReq.source_pos", "sourcePos", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var sourcePos:int;

		/**
		 *  @private
		 */
		public static const TARGET_POS:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.storage.CMoveItemReq.target_pos", "targetPos", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		public var targetPos:int;

		/**
		 *  @private
		 */
		public static const ITEM:FieldDescriptor$TYPE_MESSAGE = new FieldDescriptor$TYPE_MESSAGE("com.msg.storage.CMoveItemReq.item", "item", (4 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, function():Class { return com.msg.item.Unit; });

		private var item$field:com.msg.item.Unit;

		public function clearItem():void {
			item$field = null;
		}

		public function get hasItem():Boolean {
			return item$field != null;
		}

		public function set item(value:com.msg.item.Unit):void {
			item$field = value;
		}

		public function get item():com.msg.item.Unit {
			return item$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_ENUM(output, this.movDirect);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.sourcePos);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.targetPos);
			if (hasItem) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, item$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var mov_direct$count:uint = 0;
			var source_pos$count:uint = 0;
			var target_pos$count:uint = 0;
			var item$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (mov_direct$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMoveItemReq.movDirect cannot be set twice.');
					}
					++mov_direct$count;
					this.movDirect = com.netease.protobuf.ReadUtils.read$TYPE_ENUM(input);
					break;
				case 2:
					if (source_pos$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMoveItemReq.sourcePos cannot be set twice.');
					}
					++source_pos$count;
					this.sourcePos = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (target_pos$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMoveItemReq.targetPos cannot be set twice.');
					}
					++target_pos$count;
					this.targetPos = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 4:
					if (item$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMoveItemReq.item cannot be set twice.');
					}
					++item$count;
					this.item = new com.msg.item.Unit();
					com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, this.item);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
