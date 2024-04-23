<script>
    import { computed } from 'vue'
    import { useStore } from '../../store'
    export default {
        name:'AppLoadingMask',
        setup(){
            const store = useStore()
            const isLoading = computed({
                get(){return store.$state.isLoading},
                set(){}
            })
            return {isLoading}
        }
    }
</script>
<template>
    <Dialog v-model:visible="isLoading" modal :closable="false" :style="'width:50%;border:0'">
        <template #container>
            <div class="flex flex-column border-round-xs p-0" style="width:100%;height:100%;border: 0; background-color: rgba(0, 0, 0, 0.5)">
                <ProgressBar mode="indeterminate" style="height: 7px;width:100%"></ProgressBar>
            </div>
        </template>
    </Dialog>
</template>
<style scoped>
</style>