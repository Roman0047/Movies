# Vue 3 optimization

### Vuetify

Connect MDI icons as a link in the index.html file, it saves **1.8s** of First Contentful Paint,
Largest Contentful Paint and Speed Index, but adds **100ms** to the Total Blocking Time

Before | After
:-:|:-:
![photo_2024-03-05_21-12-47](https://github.com/Roman0047/Movies/assets/88735800/71993e48-e688-4ac5-9fba-4f3b4ce66b50) | ![photo_2024-03-05_21-14-02](https://github.com/Roman0047/Movies/assets/88735800/6b4c5e42-eb88-4f45-989a-c0a3c6577c77)

### Vue directives

`v-once`: Disables re-rendering of all child elements and components

`v-memo:`: Similar to `v-once` but has the ability to add exceptions for rendering `v-memo="[value, count]"`

### Vue lazy loading

**Load heavy components with libraries usage as chunks** by using `defineAsyncComponent` hook.
It reduces the size of the initial vendors file and creates a chunk containing the component.

`Suspense` component provides the ability to pass the props to lazy loaded component, as well as
add a placeholder or loader

```vue
<template>
  <Suspense>
    <template #default>
      <Content :content="content" />
    </template>
    <template #fallback>
      <Loading />
    </template>
  </Suspense>
</template>

<script setup>
const Content = defineAsyncComponent(() =>
  import('@/components/Content.vue')
)
</script>
```

### General vue optimization

**Prevent all list items from being re-rendered** by passing clear props to components. It's more effective
to pass completed conditions as props `is-active="activeId === item.id"` instead of passing parts of the condition
`active-id="activeId"` and applying conditions inside the component `v-if="activeId === item.id"`. In the first
situation, only two list components are re-rendering when activeId changes, but in the second, all list items are
re-rendering