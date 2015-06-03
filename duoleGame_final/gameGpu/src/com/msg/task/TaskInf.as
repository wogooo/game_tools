package com.msg.task {
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
	public dynamic final class TaskInf extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const TASK_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.task.TaskInf.task_id", "taskId", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var taskId:int;

		/**
		 *  @private
		 */
		public static const LOOP_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.task.TaskInf.loop_id", "loopId", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		private var loop_id$field:int;

		private var hasField$0:uint = 0;

		public function clearLoopId():void {
			hasField$0 &= 0xfffffffe;
			loop_id$field = new int();
		}

		public function get hasLoopId():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set loopId(value:int):void {
			hasField$0 |= 0x1;
			loop_id$field = value;
		}

		public function get loopId():int {
			return loop_id$field;
		}

		/**
		 *  @private
		 */
		public static const REMAIN_TIME:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.task.TaskInf.remain_time", "remainTime", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		private var remain_time$field:int;

		public function clearRemainTime():void {
			hasField$0 &= 0xfffffffd;
			remain_time$field = new int();
		}

		public function get hasRemainTime():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set remainTime(value:int):void {
			hasField$0 |= 0x2;
			remain_time$field = value;
		}

		public function get remainTime():int {
			return remain_time$field;
		}

		/**
		 *  @private
		 */
		public static const RUN_ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.task.TaskInf.run_id", "runId", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		private var run_id$field:int;

		public function clearRunId():void {
			hasField$0 &= 0xfffffffb;
			run_id$field = new int();
		}

		public function get hasRunId():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set runId(value:int):void {
			hasField$0 |= 0x4;
			run_id$field = value;
		}

		public function get runId():int {
			return run_id$field;
		}

		/**
		 *  @private
		 */
		public static const RUN_LIMIT:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("com.msg.task.TaskInf.run_limit", "runLimit", (5 << 3) | com.netease.protobuf.WireType.VARINT);

		private var run_limit$field:int;

		public function clearRunLimit():void {
			hasField$0 &= 0xfffffff7;
			run_limit$field = new int();
		}

		public function get hasRunLimit():Boolean {
			return (hasField$0 & 0x8) != 0;
		}

		public function set runLimit(value:int):void {
			hasField$0 |= 0x8;
			run_limit$field = value;
		}

		public function get runLimit():int {
			return run_limit$field;
		}

		/**
		 *  @private
		 */
		public static const PROPS_TASK:FieldDescriptor$TYPE_BOOL = new FieldDescriptor$TYPE_BOOL("com.msg.task.TaskInf.props_task", "propsTask", (6 << 3) | com.netease.protobuf.WireType.VARINT);

		private var props_task$field:Boolean;

		public function clearPropsTask():void {
			hasField$0 &= 0xffffffef;
			props_task$field = new Boolean();
		}

		public function get hasPropsTask():Boolean {
			return (hasField$0 & 0x10) != 0;
		}

		public function set propsTask(value:Boolean):void {
			hasField$0 |= 0x10;
			props_task$field = value;
		}

		public function get propsTask():Boolean {
			return props_task$field;
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.taskId);
			if (hasLoopId) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, loop_id$field);
			}
			if (hasRemainTime) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, remain_time$field);
			}
			if (hasRunId) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, run_id$field);
			}
			if (hasRunLimit) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 5);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, run_limit$field);
			}
			if (hasPropsTask) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 6);
				com.netease.protobuf.WriteUtils.write$TYPE_BOOL(output, props_task$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var task_id$count:uint = 0;
			var loop_id$count:uint = 0;
			var remain_time$count:uint = 0;
			var run_id$count:uint = 0;
			var run_limit$count:uint = 0;
			var props_task$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (task_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: TaskInf.taskId cannot be set twice.');
					}
					++task_id$count;
					this.taskId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (loop_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: TaskInf.loopId cannot be set twice.');
					}
					++loop_id$count;
					this.loopId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (remain_time$count != 0) {
						throw new flash.errors.IOError('Bad data format: TaskInf.remainTime cannot be set twice.');
					}
					++remain_time$count;
					this.remainTime = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 4:
					if (run_id$count != 0) {
						throw new flash.errors.IOError('Bad data format: TaskInf.runId cannot be set twice.');
					}
					++run_id$count;
					this.runId = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 5:
					if (run_limit$count != 0) {
						throw new flash.errors.IOError('Bad data format: TaskInf.runLimit cannot be set twice.');
					}
					++run_limit$count;
					this.runLimit = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 6:
					if (props_task$count != 0) {
						throw new flash.errors.IOError('Bad data format: TaskInf.propsTask cannot be set twice.');
					}
					++props_task$count;
					this.propsTask = com.netease.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
